# =========================================================================
# Define all module input variables here
# =========================================================================
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

# ============================================
# VPC configuration variables
# ============================================
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

# ============================================
# Security Group variables
# ============================================
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

# ============================================
# ALB configuration variables
# ============================================
variable "listener_port" {
  description = "Port for the ALB listener"
  type        = number
}

variable "listener_protocol" {
  description = "Protocol for the ALB listener"
  type        = string
}

variable "health_check_path" {
  description = "Health check endpoint path"
  type        = string
}

variable "health_check_protocol" {
  description = "Protocol for the health check"
  type        = string
}

variable "health_check_port" {
  description = "Port for the health check"
  type        = string
}

variable "health_check_interval" {
  description = "Interval between health checks"
  type        = number
}

variable "health_check_timeout" {
  description = "Timeout for the health check"
  type        = number
}

variable "healthy_threshold" {
  description = "Number of consecutive successful health checks before considering the target healthy"
  type        = number
}

variable "unhealthy_threshold" {
  description = "Number of consecutive failed health checks before considering the target unhealthy"
  type        = number
}

variable "health_check_matcher" {
  description = "HTTP codes to use when checking for a successful response from a target"
  type        = string
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the ALB"
  type        = bool
}

variable "enable_cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing for the ALB"
  type        = bool
}

variable "ssl_certificate_arn" {
  description = "ARN of the SSL certificate for HTTPS listener"
  type        = string
  default     = ""
}

# ============================================
# ECS configuration variables
# ============================================

variable "enable_container_insights" {
  description = "Enable Container Insights for ECS Cluster."
  type        = bool
}

variable "container_name" {
  description = "The name of the container in the ECS task."
  type        = string
}

variable "container_image" {
  description = "The Docker image to use for the container."
  type        = string
}

# Task Configurations

variable "task_cpu" {
  description = "CPU units for task (256=0.25 vCPU, 512=0.5 vCPU, 1024=1 vCPU)"
  type        = string

  validation {
    condition     = contains(["256", "512", "1024", "2048", "4096"], var.task_cpu)
    error_message = "task_cpu must be one of the following values: 256, 512, 1024, 2048, 4096."
  }
}

variable "task_memory" {
  description = "Memory for task (512=0.5GB, 1024=1GB, 2048=2GB, 3072=3GB, 4096=4GB, 8192=8GB, 16384=16GB)"
  type        = string

  validation {
    condition     = contains(["512", "1024", "2048", "3072", "4096", "8192", "16384"], var.task_memory)
    error_message = "task_memory must be one of the following values: 512, 1024, 2048, 3072, 4096, 8192, 16384."
  }
}

variable "desired_count" {
  description = "The desired number of ECS tasks to run."
  type        = number 
}

variable "enable_ecs_exec" {
  description = "Enable ECS Exec for the ECS tasks."
  type        = bool
}

variable "deployment_maximum_percent" {
  description = "The maximum percentage of tasks that can be running during a deployment."
  type        = number
}

variable "deployment_minimum_healthy_percent" {
  description = "The minimum percentage of tasks that must remain healthy during a deployment."
  type        = number
}

# Logging Configurations
variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs for ECS."
  type        = number
  default     = 30
}

variable "health_check_grace_period_seconds" {
  description = "The period of time, in seconds, that the ECS service scheduler ignores unhealthy Elastic Load Balancing target health checks after a task has first started."
  type        = number
}