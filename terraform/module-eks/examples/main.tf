module "module_uat_test" {
    source = "../terraform/module-eks" # source path from the root of the repo 
    # depends_on = [ module.module_vpc ]

    #################### EKS Cluster details ####################
    eks_cluster_name = local.eks_cluster_name
    eks_cluster_iam_role_name = "iu-uat-test-eks-cluster-role-ap-south-1"
    private_subnet_filter = ["IU-UAT-NEW-PRIVATE-SUBNET-1A", "IU-UAT-NEW-PRIVATE-SUBNET"]
    public_subnet_filter = ["IU-UAT-NEW-PUBLIC-SUBNET"]
    
    #################### Node group details ####################
    nodegroup_one_name = local.eks_nodegroup_one_name
    eks_node_group_iam_role_name = "iu-uat-test-eks-node-group-role-ap-south-1"
    subnet_ids = ["subnet-0c93c0b4c48c4b597", "subnet-0edd0a6e14975f95e"]
    ami_type   = "AL2_x86_64"
    capacity_type   = "ON_DEMAND"
    instance_types  = ["t3.large"]
    volume_size = 128
    volume_type = "gp2"
    eks_launch_template = local.eks_launch_template

    #################### EKS Addon details ####################
    cloudwatch_addon_name = "amazon-cloudwatch-observability"
    cloudwatch_addon_version = "v1.2.0-eksbuild.1"
    ebs_csi_driver_name = "aws-ebs-csi-driver"
    ebs_csi_driver_version = "v1.26.0-eksbuild.1"

    tags  = {
        "Name" = "${var.deploy_id_prefix}-${var.cluster_name}"
    }
}
