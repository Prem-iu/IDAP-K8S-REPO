data "aws_subnets" "sit_private_subnets" {
   filter {
    name   = "tag:Name"
    values = ["IU-Private-EKS-01", "IU-Private-EKS-02"]
  }
}

resource "aws_eks_cluster" "eks_cluster" {
  name                      = var.eks_cluster_name
  role_arn                  = aws_iam_role.eks_cluster_role.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  version                   = var.eks_cluster_version
  vpc_config {
    endpoint_private_access = true
    endpoint_public_access = true
    subnet_ids = data.aws_subnets.sit_private_subnets.ids
  }
  tags = var.tags
}

resource "aws_eks_node_group" "eks_cluster_nodegroup_one" {

  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.nodegroup_one_name
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  # subnet_ids      = ["subnet-0edd0a6e14975f95e", "subnet-0c93c0b4c48c4b597"]
  subnet_ids      = data.aws_subnets.sit_private_subnets.ids
  ami_type        = "AL2_x86_64"
  capacity_type   = "ON_DEMAND"
  instance_types  = ["m6a.4xlarge"]

  launch_template {
    id = aws_launch_template.eks_launch_template.id
    version = aws_launch_template.eks_launch_template.latest_version
  }

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_read_only,
    aws_iam_role_policy_attachment.amazon_ebs_csi_driver_policy,
    aws_iam_role_policy_attachment.amazon_s3_policy,
    aws_launch_template.eks_launch_template
  ]
  tags = var.tags

}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  count = var.create && var.enable_irsa ? 1 : 0

  client_id_list  = distinct(compact(concat(["sts.${local.dns_suffix}"], var.openid_connect_audiences)))
  thumbprint_list = [data.external.thumbprint.result.thumbprint]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

locals {
  dns_suffix = coalesce(var.cluster_iam_role_dns_suffix, data.aws_partition.current.dns_suffix)
}

resource "aws_launch_template" "eks_launch_template" {
  name = var.eks_launch_template
  
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 128
      volume_type = "gp2"
      encrypted   = true
    }
  }
}

