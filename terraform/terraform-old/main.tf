#
# Ref: https://github.com/jdluther2020/terraform-create-eks-k8s-cluster.git
#
# Create EKS Cluster - Entry Point
#

terraform {
  backend "s3" {
    bucket = "terraform-state-iu"
    key = "EKSClusters/terraform.tfstate"
    region = "ap-south-1"
    profile = "iu"
  }
}


locals {
  eks_vpc_name           = "${var.deploy_id_prefix}-${var.vpc_name}"
  eks_cluster_name       = "${var.deploy_id_prefix}-${var.cluster_name}"
  eks_nodegroup_one_name = "${var.deploy_id_prefix}-${var.cluster_name}-nodegroup-one"
  sti_cluster_name       = "sit-data-platform-eks-cluster"
}


module "module_vpc" {
  source = "./module-vpc"

  vpc_name         = local.eks_vpc_name
  tag_cluster_name = local.eks_cluster_name
}

# module "module_eks" {
#   source = "./module-eks"

#   cluster_name       = local.eks_cluster_name
#   nodegroup_one_name = local.eks_nodegroup_one_name
#   vpc_subnet_ids     = module.module_vpc.vpc_private_subnet_ids
# }

module "module_sit" {
  source = "./module-sit"
  providers = {
    aws = aws.apsouth1
  }

  nodegroup_one_name = "sit-data-platform-eks-cluster-nodegroup-one"
}

module "module_uat" {
  source = "./module-uat"
  providers = {
    aws = aws.apsouth1
  }

  nodegroup_one_name = "uat-data-platform-eks-cluster-nodegroup-one"
}

module "module_prod" {
  source = "./module-prod"
  providers = {
    aws = aws.apsouth1
  }

  nodegroup_one_name = "prod-data-platform-eks-cluster-nodegroup-one"
}