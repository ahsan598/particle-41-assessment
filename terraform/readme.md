# Terraform Infrastructure Deployment (AWS ECS Fargate)

This repository contains Terraform code to deploy a production-style AWS ECS Fargate setup for the Simple Time Service container. It provisions a VPC, public/private subnets, an internet-facing ALB, and an ECS service running tasks in private subnets only.

- VPC with 2 public + 2 private subnets
- ECS Fargate cluster + service running in private subnets only
- Public Application Load Balancer in public subnets
- Proper IAM roles, security groups, NAT, routing
- Fully parameterized through `variables.tf` with defaults in `terraform.tfvars`


### 🧰 Prerequisites
| Tool          | Purpose                              | Docs                                 |
| ------------- | ------------------------------------ | -------------------------------------- |
| **Terraform** | Provision AWS Infrastructure         | Refer this document [here](https://developer.hashicorp.com/terraform)      |
| **AWS CLI**   | Authentication & access              | Refer this document [here](https://docs.aws.amazon.com/cli/latest/)       |
| **Docker**    | Build & publish your container image | Refer this document [here](https://docs.docker.com/get-docker/)              |


> Note: AWS account is required. Ensure your AWS CLI is configured using
>  
> `aws configure` and give your creds like Access Key, default region etc...


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

1. Clone the repo
```sh
# Clone the repository
git clone https://github.com/ahsan598/particle-41-assessment.git

# Move into the project directory
cd particle-41-assessment/terraform
```
2. Update `terraform.tfvars` or use the default values provided.

**📌 Important Notes**
- `container_image` → Must point to your Docker image
- `container_port` → Must match the port your app listens on
(Example: `8085` if your app exposes `8085`)


3. Initialize, validate and plan configuration
```sh
# Install required providers plugins and modules
terraform init

# Check for syntax or config errors
terraform validate

# See what resources will be created before actual deploy
terraform plan
```

4. Apply Infrastructure using below options
```sh
# Option A: Recommended (Using Plan File)

# Shows what Terraform will create, update, or delete and saves the exact changes to a plan file for later use
terraform plan -out plan.tfplan

# Applies exactly what was reviewed in the plan file, ensuring safe, consistent, and production-grade deployments
terraform apply "plan.tfplan" 

# Option B: Quick Apply
terraform apply --auto-approve
```

5. After deployment, check important outputs:
```sh
terraform output
```

### 🧩 Optional: Apply in Stages (Safer for Debugging)

Use this if you want to debug step-by-step 👇
```sh
# Stage 1: VPC
terraform apply -target=module.vpc

# Stage 2: Security Groups
terraform apply -target=module.security_groups

# Stage 3: Application Load Balancer
terraform apply -target=module.alb

# Stage 4: ECS
terraform apply -target=module.ecs
```

### Verify the deployment
1. Access the Application, Get the ALB DNS name
```sh
terraform output alb_dns_name

# Open in browser
http://<alb_dns_name>
```

2. Check ECS Tasks & Service Status
```sh
aws ecs list-tasks --cluster <ecs_cluster_name>

aws ecs describe-services \
  --cluster <ecs_cluster_name> \
  --services <ecs_service_name>
```


### Teardown all resources
To remove all provisioned resources:
```sh
# Destroy all resources
terraform destroy --auto-approve
```
⚠️ This will delete VPC, ALB, ECS, Logs — everything.


###  🎉 Done!

Your Docker app is now live on AWS ECS + ALB using Terraform