# idap-kubernetes

## Pre-requisites installation
1. Installing kubectl: https://kubernetes.io/docs/tasks/tools/
2. Installing terraform: https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
3. Installing awscli: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

## ⭐ Flow for creating new cluster and timescaledb
1. Create a new module for the EKS cluster.
2. Write the terraform for the EKS, NodeGroup, IAM policies. You can refer to module-prod module to create a new cluster.
3. Apply the terraform to create the EKS cluster
4. To connect to the cluster, update local kube config file with the following command -<br>
    `aws eks update-kubeconfig --region ap-south-1 --name <<cluster name>> --profile iu`
5. For EKS to create/access volumes you will need to install the aws-ebs-csi-driver. [You can follow this link which show how to instal the AWS EBS CSI Driver](https://www.stacksimplify.com/aws-eks/kubernetes-storage/install-aws-ebs-csi-driver-on-aws-eks-for-persistent-storage/) or this [AMAZON EBS CSI DRIVER
 Installation article](https://archive.eksworkshop.com/beginner/170_statefulset/ebs_csi_driver/)
6. You can now install the helm chart. Update the required values in values.yaml file.
7. Run Helm install to install the chart
8. The timescaledb pod will initialized but will be in pending state. It is waiting for Volumes to be claimed.
9. Create the required EBS volumes based on the values provided in persistentVolumes fields in the values.yaml file.
10. Create new PV in EKS using the volumeIds of volumes you just created. You can refer to prod-pv.yaml file in extra-yaml folder.
11. Once the PV is created, timescale will claim those volumes and pod should go in running state.
12. To make the database accessible through VPC/VPN, you need to create a internal NLB. Refer to the prod-nlb-internal.yaml file for creation of it.
13. You can now use the NLB URL to access the database from VPN.



### ⭐ Create a public NLB - 
You can run the following command to create a publicly accessible NLB - <br>
`kubectl expose service timescabledb --port=5432 --target-port=5432 --type=LoadBalancer --name=my-release-timescaledb-load-balancer -n default`

### ⭐ Update tcp_keepalives_idle and other postgres options flow
1. You can connect to the database and run the ALTER commands to change options and their values - <br>
`ALTER SYSTEM SET tcp_keepalives_idle='200';`
2. Reload the postgres config -<br>
`SELECT pg_reload_conf();`
3. check if the values has changed -<br>
`SELECT name, setting FROM pg_settings where name = 'tcp_keepalives_idle';` 
