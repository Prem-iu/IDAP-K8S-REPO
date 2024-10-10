# Module: EKS Infrastructure for UAT Testing

## Overview
This Terraform module deploys an Amazon Elastic Kubernetes Service (EKS) cluster for UAT testing purposes, along with associated resources such as EKS Node Groups, EKS Addons, and IAM roles.

## Resources Created
The module will create the following AWS resources:

### Amazon EKS Cluster
- **Name:** iu-uat-test-data-platform-eks-cluster
- **VPC Configuration:**
  - Public and Private subnets
  - Internet and NAT Gateways
  - EKS Cluster Security Group
- **Cluster Addons:**
  - CloudWatch Observability
  - EBS CSI Driver

### EKS Node Group
- **Name:** iu-uat-test-data-platform-eks-cluster-nodegroup-one
- **Instance Configuration:**
  - AMI Type: AL2_x86_64
  - Instance Type: t3.large
  - On-Demand Capacity
  - EKS-optimized Amazon Linux 2 AMI
  - EBS Volume: 128 GB, gp2 type

### IAM Roles
- **EKS Cluster Role:**
  - Name: iu-uat-test-eks-cluster-role-ap-south-1
  - Assume Role Policy for EKS Cluster

- **EKS Node Group Role:**
  - Name: iu-uat-test-eks-node-group-role-ap-south-1
  - Assume Role Policy for EC2 instances in EKS Node Group
  - Attached Policies:
    - AmazonEKSClusterPolicy
    - AmazonEKSWorkerNodePolicy
    - AmazonEKS_CNI_Policy
    - CloudWatchAgentServerPolicy
    - AmazonEC2ContainerRegistryReadOnly
    - AWSXrayWriteOnlyAccess
    - AmazonS3FullAccess

- **EKS EBS CSI Driver Role:**
  - Name: iu-sit-ap-south-1-eks-ebs-csi-driver
  - Attached Policy:
    - AmazonEBSCSIDriverPolicy

### Launch Template
- **Name:** iu-uat-test-data-platform-eks-cluster-launch-template
- **Block Device Mappings:**
  - Encrypted EBS volume of 128 GB with gp2 type