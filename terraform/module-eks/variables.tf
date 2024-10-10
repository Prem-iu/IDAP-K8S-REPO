variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
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

variable "eks_launch_template" {
  description = "Name of the launch template used for EKS node group"
  type = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "eks_cluster_iam_role_name" {
  description = "IAM role name of the EKS cluster"
  type = string
}

variable "eks_node_group_iam_role_name" {
  description = "IAM role name of the EKS cluster"
  type = string
}

variable "ebs_csi_driver_name" {
  description = "Name of the ebs csi driver addon for EKS"
  type = string
  default = "aws-ebs-csi-driver"
}

variable "ebs_csi_driver_version" {
  description = "Version of ebs csi driver to be installed"
  type = string
}

variable "cloudwatch_addon_name" {
  description = "Name of the cloudwatch eks addon to be installed"
  type = string
  default = "amazon-cloudwatch-observability"
}

variable "cloudwatch_addon_version" {
  description = "Version of cloudwatch eks addon to be installed"
  type = string
}

variable "private_subnet_filter" {
  type = list(string)
  description = <<EOM
  filters to get the private subnet ids, below is how you provide the values
  private_subnet_filter = ["IU-UAT-NEW-PRIVATE-SUBNET-1A", "IU-UAT-NEW-PRIVATE-SUBNET"]
  EOM
}

variable "public_subnet_filter" {
  type =  list(string)
  description = <<EOM
  filters to get the public subnet ids, below is how you provide the values
  public_subnet_filter = ["IU-UAT-NEW-PUBLIC-SUBNET"]
  EOM
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster node_group"
  type        = list(string)
}

variable "ami_type" {
  description = "The type of Amazon Machine Image (AMI) for the node group"
  type        = string
}

variable "capacity_type" {
  description = "The capacity type for the node group (ON_DEMAND or SPOT)"
  type        = string
  default     = "ON_DEMAND"
}

variable "instance_types" {
  description = "List of EC2 instance types for the node group"
  type        = list(string)
}

variable "volume_size" {
  description = "The size of the EBS volume in gigabytes for the EKS nodes"
  type        = number
}

variable "volume_type" {
  description = "The type of EBS volume for the EKS nodes"
  type        = string
}

variable "encrypted" {
  description = "Whether the EBS volume of the node_group should be encrypted or not, this should always be true"
  type        = bool
  default     = true
}
