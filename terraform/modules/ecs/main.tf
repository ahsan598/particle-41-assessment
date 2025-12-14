# ===========================================================================
# Module: ECS Tasks
# This module sets up an ECS Tasks within the VPC created in the VPC module.
# ===========================================================================

# ============================================
# ECS CLUSTER
# ============================================
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  # Enable Container Insights for monitoring
  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  # Cluster configuration
  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"
      
      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.ecs.name
      }
    }
  }

  tags = {
    Name = "${var.project_name}-ecs-cluster"
  }
}

# ============================================
# Cloudwatch Log Group for ECS
# ============================================
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = var.log_retention_days

  tags = {
    Name = "${var.project_name}-ecs-logs"
  }
}

# ============================================
# ECS Task Definition (Fargate)
# ============================================
resource "aws_ecs_task_definition" "main" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  # IAM roles for task execution and task
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn    # For ECS to pull images and write logs
  task_role_arn            = aws_iam_role.ecs_task.arn              # For container to access AWS services

# Container Definitions
  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image

      # Essential container (task fails if this fails)
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

        logConfiguration = {
          logDriver = "awslogs"
          options = {
            "awslogs-group"         = aws_cloudwatch_log_group.ecs.name
            "awslogs-region"        = data.aws_region.current.name
            "awslogs-stream-prefix" = "ecs"
          }
        }
    }
  ])

  tags = {
    Name = "${var.project_name}-ecs-task"
  }
}

# ============================================
# ECS SERVICE (Deploys and manages tasks)
# ============================================
resource "aws_ecs_service" "main" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

# Use the latest platform version for Fargate
  platform_version = "LATEST"

  network_configuration {
    subnets         = var.private_subnet_ids        # Private subnets
    security_groups = var.security_group_ids
    assign_public_ip = false                        # No public IP (uses NAT for outbound)
  }

  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent

# Load balancer configuration
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  # Propagate tags from task definition
  propagate_tags = "TASK_DEFINITION"
  
  # Enable ECS Exec (for debugging)
  enable_execute_command = var.enable_ecs_exec
  
  # Health check grace period
  health_check_grace_period_seconds = var.health_check_grace_period_seconds
  
  # Wait for ALB to be ready
  depends_on = [
    aws_iam_role_policy_attachment.ecs_task_execution
  ]

  tags = {
    Name = "${var.project_name}-ecs-service"
  } 
}