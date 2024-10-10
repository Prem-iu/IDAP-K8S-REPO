# EKS Cluster Setup

## Installing Prerequisites

1. **AWS CLI:**
   - Follow the official AWS CLI installation guide: [Installing the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

2. **Terraform:**
   - Follow the official Terraform installation guide: [Installing Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

3. **kubectl:**
   - Follow the official Kubernetes documentation for installing `kubectl`: [Install and Set Up kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

4. **Helm:**
   - Follow the official Helm installation guide: [Installing Helm](https://helm.sh/docs/intro/install/)

## Bootstrapping the EKS Cluster with Terraform

1. Clone the repository:

    ```bash
    git clone <repository-url>
    cd <repository-directory>
    mkdir <new-repo-to-create-the-cluster> # At the root of the repository 
    ```
2. From the root of the directory navigate to the below for the instructions on how to  create a new cluster:

    ```bash
    cd terraform/module-eks/example/
    ```

    Follow the prompts and confirm the changes to provision the EKS cluster.

## Setting AWS CLI Context for EKS Cluster

After bootstrapping the EKS cluster, set the AWS CLI context to the newly created cluster:

```bash
aws eks --region <region> update-kubeconfig --name <eks-cluster-name> --profile iu
