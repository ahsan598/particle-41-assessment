# ===================================================================
# Module: Security Groups for ALB and ECS Tasks
# Security Group for Application Load Balancer (public facing) and
# ECS Tasks (private).
# ===================================================================

# ============================================
# ALB SECURITY GROUP (Public-facing)
# ============================================
resource "aws_security_group" "alb_sg" {
  name_prefix = "${var.project_name}-alb-sg-"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

# Allow deletion and recreation (name_prefix requires this)
  lifecycle {
    create_before_destroy = true 
  }

  tags    = {
    Name  = "${var.project_name}-alb-sg"
  }
}

# =================================================
# ALB Ingress - Allow HTTP traffic from internet
# =================================================
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb_sg.id
  description       = "Allow HTTP inbound traffic from internet"

  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  
  tags   = {
    Name = "${var.project_name}-alb-http"
  }
}

# ==============================================================
# ALB Ingress - Allow HTTPS traffic from internet (if enabled)
# ==============================================================
resource "aws_vpc_security_group_ingress_rule" "alb_inbound" {
  count             = var.enable_https ? 1 : 0
  security_group_id = aws_security_group.alb_sg.id
  description       = "Allow HTTPS inbound traffic from internet"

  cidr_ipv4         = "0.0.0.0/0"       # Allow from anywhere
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"

  tags   = {
    Name = "${var.project_name}-alb-https"
  }
}

# ==============================================================
# ALB Egress - Allow traffic to ECS tasks on container port
# ==============================================================
resource "aws_vpc_security_group_egress_rule" "alb_to_ecs" {
  security_group_id            = aws_security_group.alb_sg.id
  description                  = "Allow traffic to ECS tasks"

  referenced_security_group_id = aws_security_group.ecs_sg.id
  from_port                    = var.container_port
  to_port                      = var.container_port
  ip_protocol                  = "tcp"

  tags   = {
    Name = "${var.project_name}-alb-to-ecs"
  }
}

# ============================================
# ECS SECURITY GROUP (Private subnets)
# ============================================
resource "aws_security_group" "ecs_sg" {
  name_prefix = "${var.project_name}-ecs-sg-"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

# Ensure SG is created before destroying the old one
  lifecycle {
    create_before_destroy = true 
  }

  tags   = {
    Name = "${var.project_name}-ecs-sg"
  }
}

# ================================================
# ECS Ingress - Allow traffic only from ALB
# ================================================
resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id            = aws_security_group.ecs_sg.id
  description                  = "Allow traffic from ALB only"

  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = var.container_port
  to_port                      = var.container_port
  ip_protocol                  = "tcp"

  tags   = {
    Name = "${var.project_name}-ecs-from-alb"
  }
}

# ============================================================================
# ECS Egress - Allow HTTPS traffic to internet (for image pulls, API calls)
# ============================================================================
resource "aws_vpc_security_group_egress_rule" "ecs_https" {
  security_group_id = aws_security_group.ecs_sg.id
  description       = "Allow HTTPS traffic to internet for image pulls"

  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"

  tags   = {
    Name = "${var.project_name}-ecs-https"
  }
}

# ============================================================================
# ECS Egress - Allow HTTP traffic to internet (optional, for package updates)
# ============================================================================
resource "aws_vpc_security_group_egress_rule" "ecs_http" {
  security_group_id = aws_security_group.ecs_sg.id
  description       = "Allow HTTP traffic to internet for package updates"

  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"

  tags   = {
    Name = "${var.project_name}-ecs-http"
  }
}

# ================================================
# ECS Egress: Allow DNS resolution (UDP 53)
# ================================================
resource "aws_vpc_security_group_egress_rule" "ecs_dns" {
  security_group_id = aws_security_group.ecs_sg.id
  description       = "Allow DNS queries"
  
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 53
  to_port     = 53
  ip_protocol = "udp"

  tags = {
    Name = "ecs-dns-egress"
  }
}

# ============================================
# OPTIONAL: VPC ENDPOINTS SECURITY GROUP
# ============================================
# For private ECS tasks to access AWS services without NAT
resource "aws_security_group" "vpc_endpoints" {
  count       = var.enable_vpc_endpoints ? 1 : 0
  name_prefix = "${var.project_name}-vpce-sg-"
  description = "Security group for VPC endpoints"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.project_name}-vpce-sg"
    Type = "VPCEndpoint"
  }
}

# VPC Endpoint Ingress: Allow traffic from ECS
resource "aws_vpc_security_group_ingress_rule" "vpc_from_ecs" {
  count             = var.enable_vpc_endpoints ? 1 : 0
  security_group_id = aws_security_group.vpc_endpoints[0].id
  description       = "Allow traffic from ECS tasks"
  
  referenced_security_group_id = aws_security_group.ecs_sg.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"

  tags = {
    Name = "vpce-from-ecs-ingress"
  }
}