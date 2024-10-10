variable "sit_cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "sit-data-platform-eks-cluster"
}

variable "nodegroup_one_name" {
  description = "Nodegroup (group one) name to be used"
  type        = string
}


