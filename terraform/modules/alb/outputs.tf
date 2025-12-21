# ===================================================
# Outputs for Application Load Balancer Module
# ===================================================
output "alb_id" {
  description = "The ID of the Application Load Balancer"
  value       = aws_lb.main.id
}

output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "ALB hosted zone ID (for Route53 alias records)"
  value       = aws_lb.main.zone_id
}

output "target_group_id" {
  description = "Target group ID"
  value       = aws_lb_target_group.ecs.id
}

output "target_group_arn" {
  description = "The ARN of the ALB Target Group"
  value       = aws_lb_target_group.ecs.arn
}

output "http_listener_arn" {
  description = "The ARN of the ALB HTTP Listener"
  value       = aws_lb_listener.http.arn
}

output "https_listener_arn" {
  description = "The ARN of the ALB HTTPS Listener"
  value       = var.enable_https ? aws_lb_listener.https[0].arn : null
}
