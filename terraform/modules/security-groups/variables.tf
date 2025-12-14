# ===================================================================
# Variables for Security Groups Module
# This module defines the security groups for ALB and ECS Tasks.
# ===================================================================

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_id" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "enable_https" {
  description = "Enable HTTPS ingress rule for ALB"
  type        = bool
}

variable "container_port" {
  description = "Port on which the ECS container listens"
  type        = number

  validation {
    condition     = var.container_port > 0 && var.container_port < 65536
    error_message = "container_port must be between 1 and 65535"
  }
}
