# ============================================
# All Outputs for the Infrastructure Modules
# ============================================

# ============================================
# VPC Outputs
# ============================================
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.vpc.nat_gateway_ids
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = module.vpc.internet_gateway_id
}

# ============================================
# Security Group Outputs
# ============================================
output "alb_security_group_id" {
  description = "Security group ID for ALB "
  value       = module.security_groups.alb_security_group_id
}

output "ecs_security_group_id" {
  description = "Security group ID  for ECS tasks"
  value       = module.security_groups.ecs_security_group_id 
}

# ============================================
# ALB Outputs
# ============================================
output "alb_id" {
  description = "The ID of the Application Load Balancer"
  value       = module.alb.alb_id
}

output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = module.alb.alb_arn
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "target_group_id" {
  description = "Target group ID"
  value       = module.alb.target_group_id
}

output "target_group_arn" {
  description = "The ARN of the ALB Target Group"
  value       = module.alb.target_group_arn
}

output "http_listener_arn" {
  description = "The ARN of the ALB HTTP Listener"
  value       = module.alb.http_listener_arn
}

output "https_listener_arn" {
  description = "The ARN of the ALB HTTPS Listener"
  value       = module.alb.https_listener_arn
}

# ============================================
# ECS Outputs
# ============================================

output "ecs_cluster_id" {
  description = "The ID of the ECS Cluster."
  value       = module.ecs.ecs_cluster_id
}

output "ecs_cluster_arn" {
  description = "The ARN of the ECS Cluster."
  value       = module.ecs.ecs_cluster_arn
}

output "ecs_task_definition_arn" {
  description = "The ARN of the ECS Task Definition."
  value       = module.ecs.ecs_task_definition_arn
}

output "task_execution_role_arn" {
  description = "The ARN of the ECS Task Execution Role."
  value       = module.ecs.task_execution_role_arn
}

output "cloud_watch_log_group_name" {
  description = "The name of the CloudWatch Log Group for ECS."
  value       = module.ecs.cloud_watch_log_group_name
}