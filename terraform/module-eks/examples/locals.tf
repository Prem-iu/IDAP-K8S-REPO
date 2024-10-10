locals {
  eks_vpc_name           = "${var.deploy_id_prefix}-${var.aws_region}-${var.vpc_name}"
  eks_cluster_name       = "${var.deploy_id_prefix}-${var.cluster_name}"
  eks_nodegroup_one_name = "${var.deploy_id_prefix}-${var.cluster_name}-nodegroup-one"
  eks_launch_template    = "${local.eks_cluster_name}-launch-template"
}
