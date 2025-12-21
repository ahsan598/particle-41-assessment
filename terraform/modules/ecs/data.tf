# ============================================
# Data sources for ECS module
# ============================================

# ============================================
# Get current AWS region
# ============================================
data "aws_region" "current" {}

# ====================================================
# IAM Assume Role Policy for ECS Tasks
# Used by both task execution role and task role
# ====================================================
data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    effect = "Allow"
    
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    
    actions = ["sts:AssumeRole"]
  }
}

# ============================================================
# ECR and CloudWatch Logs Access Policy
# For task execution role to pull images and write logs
# ============================================================
data "aws_iam_policy_document" "ecs_task_execution_additional" {
  statement {
    effect = "Allow"
    
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    
    resources = ["*"]
  }
  
  statement {
    effect = "Allow"
    
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    
    resources = ["${aws_cloudwatch_log_group.ecs.arn}:*"]
  }
}

# ============================================
# ECS Exec Policy (for debugging)
# Conditional - only if enable_ecs_exec = true
# ============================================
data "aws_iam_policy_document" "ecs_exec" {
  statement {
    effect = "Allow"
    
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    
    resources = ["*"]
  }
}