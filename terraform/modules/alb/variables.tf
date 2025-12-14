# =====================================================================
# Module: Application Load Balancer (ALB) Variables
# It contains all the input variables required for configuring
# an Application Load Balancer (ALB).
# =====================================================================

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be deployed"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "alb_security_group_ids" {
  description = "Security group ID for ALB"
  type        = list(string)
}

variable "container_port" {
  description = "Port on which the ECS container is listening"
  type        = number
}

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

variable "enable_https" {
  description = "Enable HTTPS listener"
  type        = bool
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