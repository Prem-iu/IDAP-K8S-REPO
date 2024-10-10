#
# Ref: https://github.com/jdluther2020/terraform-create-eks-k8s-cluster.git
#
# Create EKS Cluster - Providers Collection
#
provider "aws" {
  region  = var.aws_region
  profile = var.profile
}

terraform {
  backend "s3" {
    bucket = "terraform-state-iu"
    key = "EKSClusters/ap-south-1/iu-uat-test-data-platform-eks-cluster/terraform.tfstate"
    region = "ap-south-1"
    profile = "iu"
  }
}
