data "aws_vpc" "prod_default_vpc" {
  filter {
    name   = "tag:Name"
    values = ["IU-Prod"]
  }
}

data "aws_subnets" "prod_default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.prod_default_vpc.id]
  }
}


resource "aws_eks_cluster" "eks_cluster" {
  name                      = var.prod_cluster_name
  role_arn                  = aws_iam_role.eks_cluster_role.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  vpc_config {

    subnet_ids = data.aws_subnets.prod_default_subnets.ids
  }

}

resource "aws_eks_node_group" "eks_cluster_nodegroup_one" {

  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.nodegroup_one_name
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = data.aws_subnets.prod_default_subnets.ids
  ami_type        = "AL2_x86_64"
  capacity_type   = "ON_DEMAND"
  instance_types  = ["m6a.16xlarge"]
  disk_size       = 512

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
  ]

}
