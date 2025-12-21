# ============================================
# IAM roles for ECS Fargate tasks
# ============================================

# ================================================================
# TASK EXECUTION ROLE: Used by ECS to pull images and write logs
# ================================================================
resource "aws_iam_role" "ecs_task_execution" {
  name               = "${var.project_name}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags   = {
    Name = "${var.project_name}-task-execution-role"
  }
}

# ============================================
# Attach AWS managed policy
# ============================================
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ===============================================
# Additional permissions for ECR and CloudWatch
# ===============================================
resource "aws_iam_role_policy" "ecs_task_execution_additional" {
  name   = "${var.project_name}-ecr-logs-access"
  role   = aws_iam_role.ecs_task_execution.id
  policy = data.aws_iam_policy_document.ecs_task_execution_additional.json
}

# ======================================================
# TASK ROLE: Used by container to access AWS services
# ======================================================
resource "aws_iam_role" "ecs_task" {
  name               = "${var.project_name}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags   = {
    Name = "${var.project_name}-task-role"
  }
}

# ==================================================
# ECS Exec policy (conditional - for debugging)
# ==================================================
resource "aws_iam_role_policy" "ecs_exec" {
  count  = var.enable_ecs_exec ? 1 : 0
  name   = "${var.project_name}-ecs-exec-policy"
  role   = aws_iam_role.ecs_task.id
  policy = data.aws_iam_policy_document.ecs_exec.json
}