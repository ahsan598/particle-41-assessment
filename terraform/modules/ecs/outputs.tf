# ===================================================================
# Outputs for ECS Tasks Module
# This module defines the output variables for the ECS Tasks module.
# ===================================================================
output "ecs_cluster_id" {
  description = "The ID of the ECS Cluster."
  value       = aws_ecs_cluster.main.id
}

output "ecs_cluster_arn" {
  description = "The ARN of the ECS Cluster."
  value       = aws_ecs_cluster.main.arn
}

output "service_id" {
  description = "ECS Service ID"
  value       = aws_ecs_service.main.id
}

output "ecs_task_definition_arn" {
  description = "The ARN of the ECS Task Definition."
  value       = aws_ecs_task_definition.main.arn
}

output "task_execution_role_arn" {
  description = "The ARN of the ECS Task Execution Role."
  value       = aws_iam_role.ecs_task_execution.arn
}

output "cloud_watch_log_group_name" {
  description = "The name of the CloudWatch Log Group for ECS."
  value       = aws_cloudwatch_log_group.ecs.name
}