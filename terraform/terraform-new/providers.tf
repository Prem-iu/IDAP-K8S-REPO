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
    bucket = "terraform-state-iu-prod-us-east-1"
    key = "EKSClusters/terraform.tfstate"
    region = "us-east-1"
    profile = "iu"
  }
}
