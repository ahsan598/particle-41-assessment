# Terraform Infrastructure Deployment (AWS ECS Fargate)

This repository contains **Terraform** code to deploy a production-style **AWS ECS Fargate** setup for the sts app container. It provisions a **VPC, subnets, ALB, and ECS service**.

### 🎯 Project Overview

- VPC with 2 public + 2 private subnets
- ECS Fargate cluster + service running in private subnets only
- Public Application Load Balancer in public subnets
- Proper IAM roles, security groups, NAT, routing
- Fully parameterized through `variables.tf` with defaults in `terraform.tfvars`


### 🧰 Prerequisites

Before you start, make sure you have installed:

| Tool          | Purpose                              | Docs                      |
| ------------- | ------------------------------------ | ------------------------- |
| **Terraform** | Provision AWS Infrastructure         | Refer this document [here](https://developer.hashicorp.com/terraform)     |
| **AWS CLI**   | Authentication & access              | Refer this document [here](https://docs.aws.amazon.com/cli/latest/)       |
| **Docker**    | Build & publish your container image | Refer this document [here](https://docs.docker.com/get-docker/)           |

**AWS Account Requirements:**
- Valid AWS account with appropriate IAM permissions
- Configured AWS credentials (`aws configure`)


### 📂 Project Structure
```cpp
terraform/
├── modules/
│   ├── vpc/                     # VPC, subnets, NAT, IGW resources
│   ├── security-groups/         # ALB and ECS SG rules
│   ├── alb/                     # ALB, target group, listener
│   └── ecs/                     # Cluster, task definition, service, IAM etc.
├── main.tf                      # Root file - calls child modules
├── variables.tf                 # Root file - input variables
├── terraform.tfvars             # Environment-specific values
├── outputs.tf                   # Root file - outputs
├── providers.tf                 # Terraform & provider version constraints
├── .gitignore                   # Files git should ignore (tfstate)
└── README.MD                    # Documentation on how to deploy the ECS Infra
```


### Architect Diagram

![architect-diagram](/terraform/assets/images/architect-diagram.png)


### 🚀 Deployment Steps

**Step-1: Clone the repo**
```sh
# Clone the repository
git clone https://github.com/ahsan598/particle-41-assessment.git

# Move into the project directory
cd particle-41-assessment/terraform
```
**Step-2: Update `terraform.tfvars` or use the default values provided.**

**📌 Important Notes**
- `container_image` → Must point to your Docker image
- `container_port` → Must match the port your app listens on
(Example: `8085` if your app exposes `8085`)


**Step-3: Initialize, validate and plan configuration**
```sh
# Install required providers plugins and modules
terraform init

# Check for syntax or config errors
terraform validate

# See what resources will be created before actual deploy
terraform plan
```

**Step-4: Apply Infrastructure using below options**
```sh
# Option A: Recommended (Using Plan File)

# Shows what Terraform will create, update, or delete and saves the exact changes to a plan file for later use
terraform plan -out plan.tfplan

# Applies exactly what was reviewed in the plan file, ensuring safe, consistent, and production-grade deployments
terraform apply "plan.tfplan" 

# Option B: Quick Apply
terraform apply --auto-approve
```

**Step-5: After deployment, check important outputs**
```sh
terraform output
```

### Verify the deployment

**Step-1: Access the Application, Get the ALB DNS name**
```sh
terraform output alb_dns_name

# Open in browser
http://<alb_dns_name>
```

**Step-2: Check ECS Tasks & Service Status**
```sh
aws ecs list-tasks --cluster <ecs_cluster_name>

aws ecs describe-services \
  --cluster <ecs_cluster_name> \
  --services <ecs_service_name>
```


### Delete all resources
**To remove all provisioned resources**
```sh
# Destroy all resources
terraform destroy --auto-approve

# This will delete VPC, ALB, ECS, Logs — everything.
``` 

**Your Docker app is now live on AWS ECS + ALB using Terraform**