# Usage Instructions

1. **File Creation:**
   - Create the following files with specific names and content:
     - `main.tf`: Customize the network configuration, names, and other parameters as needed.
     - `locals.tf`: Define local variables with custom names in this file.
     - `variables.tf`: Update the `deploy_id_prefix` variable based on the environment the cluster is created in.
     - `providers.tf`: Configure the AWS provider in this file.

2. **Customization in `providers.tf`:**
   - Ensure that you have the AWS IAM credentials of the 'Datascience-user' user. These credentials will be used by Terraform for AWS operations.
   - In `providers.tf`, locate the `backend "s3"` configuration section.
   - Update the `bucket`, `key`, `region`, and `profile` values as follows:
     - `bucket`: Specify the name of your S3 bucket for storing Terraform state.
     - `key`: Customize the path to the Terraform state file, ensuring uniqueness for each cluster.
     - `region`: Set the AWS region where your S3 bucket is located.
     - `profile`: Provide the AWS CLI profile used for authentication. Make sure to use the `DataScience-user` IAM user credentials
**Note:**
- Use the S3 bucket `terraform-state-iu` from `ap-south-1` to create all the state files
- Do not use an existing state file to create a new cluster.
- Ensure that the key in the backend S3 config is updated as required.

   Example:
   ```hcl
   terraform {
     backend "s3" {
       bucket  = "your-unique-s3-bucket-name"
       key     = "EKSClusters/your-region/your-unique-cluster-name/terraform.tfstate"
       region  = "your-aws-region"
       profile = "Datascience-user"
     }
   }

3. **Customization in `main.tf`:**
   - Open the `main.tf` file and make changes to provide your network configuration, custom names, and other relevant details.

4. **Update `deploy_id_prefix` in `variables.tf`:**
   - Open the `variables.tf` file and update the `deploy_id_prefix` variable based on the environment where the cluster is created.

5. **Terraform Initialization:**
   - Run the following commands in the directory containing the above terraform files:
     ```
     terraform init
     ```
   - This initializes the Terraform configuration.

6. **Terraform plan:**
   - Run the following command in the directory containing the above terraform files to get a plan of all the EKS cluster and associated resources to be created:
     ```
     terraform plan
     ```
7. **Terraform Apply:**
   - Run the following command in the directory containing the above terraform files to create the EKS cluster and associated resources:
     ```
     terraform apply
     ```
   Follow the prompts and confirm the changes to provision the EKS cluster.

8. **Review Output:**
   - After the apply command, review the output for any errors or additional instructions.

Feel free to customize these files further based on your specific needs and naming conventions.

## Setting AWS CLI Context for EKS Cluster

After bootstrapping the EKS cluster, set the AWS CLI context to the newly created cluster:

```bash
aws eks --region <region> update-kubeconfig --name <eks-cluster-name> --profile iu
```

9. **Terraform destroy:**
   - Run the following command in the directory containing the above terraform files to destroy the EKS cluster and the associated resources:
     ```
     terraform destroy
     ```
**Note:**
- Be mindful when using the command `terraform destroy` as it deletes all the resources in the directory
- Make sure to verify the diresctory you are in before running the terraform destroy command