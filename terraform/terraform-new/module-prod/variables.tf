variable "prod_cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "prod-data-platform-eks-cluster"
}

variable "nodegroup_one_name" {
  description = "Nodegroup (group one) name to be used"
  type        = string
}

variable "enable_irsa" {
  description = "Determines whether to create an OpenID Connect Provider for EKS to enable IRSA"
  type        = bool
  default     = true
}

variable "create" {
  description = "Controls if EKS resources should be created (affects nearly all resources)"
  type        = bool
  default     = true
}

variable "cluster_iam_role_dns_suffix" {
  description = "Base DNS domain name for the current partition (e.g., amazonaws.com in AWS Commercial, amazonaws.com.cn in AWS China)"
  type        = string
  default     = null
}

variable "openid_connect_audiences" {
  description = "List of OpenID Connect audience client IDs to add to the IRSA provider"
  type        = list(string)
  default     = []
}