# ============================================================================
# Variables for ECS Tasks Module
# This module sets up an ECS Tasks within the VPC created in the VPC module.
# ============================================================================

variable "project_name" {
  description = "The name of the project, used for naming resources."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where ECS tasks will be deployed."
  type        = string
}

variable "private_subnet_ids" {
  description = "A list of private subnet IDs for the ECS tasks."
  type        = list(string)
}

variable "security_group_ids" {
  description = "A list of security group IDs to associate with the ECS tasks."
  type        = list(string)
}

variable "target_group_arn" {
  description = "The ARN of the target group to associate with the ECS service."
  type        = string
}

# Container Configurations
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

variable "container_port" {
  description = "The port on which the container listens."
  type        = number
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

# Custom IAM Policies
variable "task_policy_statements" {
  description = "Custom IAM policy statements for task role"
  type        = any
  default     = null
}