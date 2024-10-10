#
# Ref: https://github.com/jdluther2020/terraform-create-eks-k8s-cluster.git
#
# Create EKS Cluster - Variables Collection
#
variable "profile" {
  description = "AWS credential Profile (normally found in ~/.aws/config)"
  type        = string
  default     = "iu"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "deploy_id_prefix" {
  description = "Prefix to provide an unique ID to the resources of this setup"
  type        = string
  default     = "iu-sit"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "data-platform-eks-cluster"
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "data-platform-vpc"
}

variable "eks_launch_template" {
  description = "Name of the launch template used for EKS node group"
  type = string
}