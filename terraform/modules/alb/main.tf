# =====================================================================
# Module: Application Load Balancer (ALB)
# This module sets up an ALB with HTTP and optional HTTPS listeners,
# along with a target group configured for ECS services.
# =====================================================================

# Create Application Load Balancer
resource "aws_lb" "main" {
  name                        = "${var.project_name}-alb"
  internal                    = false
  load_balancer_type          = "application"
  security_groups             = var.alb_security_group_ids
  subnets                     = var.public_subnet_ids
  enable_deletion_protection  = var.enable_deletion_protection

  # Enable cross-zone load balancing
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  tags   = {
    Name = "${var.project_name}-alb"
  }
}

# Create Target Group for ECS Service
resource "aws_lb_target_group" "ecs" {
  name        = "${var.project_name}-tg"
  port        = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

# Health Check Configuration
  health_check {
    enabled             = true
    path                = var.health_check_path
    protocol            = var.health_check_protocol
    port                = var.health_check_port
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    matcher             = var.health_check_matcher
  }

# Ensure Target Group is created before destroying the old one
  lifecycle {
    create_before_destroy = true
  }

  tags   = {
    Name = "${var.project_name}-tg"
  }

# Ensure ALB is created first
  depends_on = [ aws_lb.main ]
}

# Create Listener for ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs.arn
  }

  tags   = {
    Name = "${var.project_name}-alb-listener"
  }
}

# Create HTTPS Listener if enabled
resource "aws_lb_listener" "https" {
  count             = var.enable_https ? 1 : 0
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  
  # SSL certificate from ACM
  certificate_arn = var.ssl_certificate_arn
  ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-2021-06"  # Latest TLS policy

  # Default action: Forward to target group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs.arn
  }

  tags   = {
    Name = "${var.project_name}-https-listener"
  }
}

