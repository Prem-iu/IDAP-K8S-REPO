#
# Ref: https://github.com/jdluther2020/terraform-create-eks-k8s-cluster.git
#
# Create EKS Cluster - Entry Point
#

locals {
  eks_vpc_name           = "${var.deploy_id_prefix}-${var.aws_region}-${var.vpc_name}"
  eks_cluster_name       = "${var.deploy_id_prefix}-${var.cluster_name}"
  eks_nodegroup_one_name = "${var.deploy_id_prefix}-${var.cluster_name}-nodegroup-one"
  eks_launch_template    = "${local.eks_cluster_name}-launch-template"
}

# module "module_vpc" {
#   source = "../module-vpc"

#   vpc_name         = local.eks_vpc_name
#   tag_cluster_name = local.eks_cluster_name
# }

module "module_sit" {
  source = "./module-prod"
  # depends_on = [ module.module_vpc ]
  nodegroup_one_name = local.eks_nodegroup_one_name
  eks_cluster_name = local.eks_cluster_name
  eks_launch_template = local.eks_launch_template
  eks_cluster_version = "1.28"
  tags = {
    "Name" = "${var.deploy_id_prefix}-${var.cluster_name}"
  }
}