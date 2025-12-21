# =========================================================================
# Provide values for variables used in the Terraform configuration
# =========================================================================

# ====================================
# General configuration
# ====================================
aws_region       = "us-east-1"
environment      = "dev"
project_name     = "sts-app"

# ======================================
# VPC configuration
# ======================================
vpc_cidr                = "10.0.0.0/16"
availability_zones      = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs     = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs    = ["10.0.11.0/24", "10.0.12.0/24"]

# ====================================
# Security Group configuration
# ====================================
enable_https            = false                        # Set true if using SSL certificate
enable_vpc_endpoints    = false

# ============================================
# ALB configuration
# =============================================
listener_port                    = 80
listener_protocol                = "HTTP"

health_check_path                = "/"
health_check_protocol            = "HTTP"
health_check_port                = "traffic-port"
health_check_interval            = 30
health_check_timeout             = 5
healthy_threshold                = 2
unhealthy_threshold              = 2
health_check_matcher             = "200-399"

enable_deletion_protection       = false
enable_cross_zone_load_balancing = true

# ============================================
# ECS configuration
# ============================================
container_name                      = "sts-app"
container_image                     = "ahsan98/sts:1.0"

container_port                      = 8080
task_cpu                            = "256"
task_memory                         = "512"
desired_count                       = 2

deployment_maximum_percent          = 200
deployment_minimum_healthy_percent  = 100
health_check_grace_period_seconds   = 60

enable_container_insights           = true
enable_ecs_exec                     = true