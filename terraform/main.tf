# =============================================================
# Main Terraform configuration file
# =============================================================
module "vpc" {
  source               = "./modules/vpc"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security_groups" {
  source                = "./modules/security-groups"
  
  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id     # From VPC module output                    
  container_port        = var.container_port
  enable_https          = var.enable_https
  enable_vpc_endpoints  = var.enable_vpc_endpoints
}

module "alb" {
  source                           = "./modules/alb"
  
  project_name                     = var.project_name
  vpc_id                           = module.vpc.vpc_id
  public_subnet_ids                = module.vpc.public_subnet_ids                       # From VPC module output
  alb_security_group_ids           = [module.security_groups.alb_security_group_id]     # From Security Groups module output

  container_port                   = var.container_port
  listener_port                    = var.listener_port
  listener_protocol                = var.listener_protocol

  health_check_path                = var.health_check_path
  health_check_protocol            = var.health_check_protocol
  health_check_port                = var.health_check_port
  health_check_interval            = var.health_check_interval
  health_check_timeout             = var.health_check_timeout
  healthy_threshold                = var.healthy_threshold
  unhealthy_threshold              = var.unhealthy_threshold
  health_check_matcher             = var.health_check_matcher

  enable_deletion_protection       = var.enable_deletion_protection
  ssl_certificate_arn              = var.ssl_certificate_arn

  enable_https                     = var.enable_https
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
}

module "ecs" {
  source                             = "./modules/ecs"

  project_name                       = var.project_name
  vpc_id                             = module.vpc.vpc_id
  private_subnet_ids                 = module.vpc.private_subnet_ids                       # From VPC module output
  security_group_ids                 = [module.security_groups.ecs_security_group_id]      # From Security Groups module output

  target_group_arn                   = module.alb.target_group_arn                         # From ALB module output

  container_name                     = var.container_name
  container_image                    = var.container_image
  container_port                     = var.container_port

  task_cpu                           = var.task_cpu
  task_memory                        = var.task_memory
  desired_count                      = var.desired_count

  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  health_check_grace_period_seconds  = var.health_check_grace_period_seconds

  enable_container_insights          = var.enable_container_insights
  enable_ecs_exec                    = var.enable_ecs_exec
}