#
# Ref: https://github.com/jdluther2020/terraform-create-eks-k8s-cluster.git
#
# Create EKS Cluster - VPC Module - Entry Point
#

data "aws_availability_zones" "available" {}

#
# Module Ref: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
#
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name                 = var.vpc_name
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true # enable_nat_gateway, bool, should be true to provision NAT Gateways for each the private networks
  single_nat_gateway   = true # single_nat_gateway, bool, should be true to provision a single shared NAT Gateway across all private networks
  enable_dns_hostnames = true
  map_public_ip_on_launch = true


  tags = {
    "kubernetes.io/cluster/${var.tag_cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.tag_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
    "Name"                                        = "IU-Public-EKS"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.tag_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
    "Name"                                        = "IU-Private-EKS"
  }
}
