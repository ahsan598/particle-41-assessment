# =================================================================
# Specify the required Terraform version and AWS provider version
# =================================================================

# ============================================
# VERSION CONSTRAINT
# ============================================
terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


# ============================================
# PROVIDER CONFIGURATION
# ============================================
provider "aws" {
  region = var.aws_region

# Set default tags for all AWS resources
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  }
}
