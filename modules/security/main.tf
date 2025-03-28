locals {
  name_prefix = "${var.project}-${var.environment}"
}

# ALB Security Group - Permite HTTP/HTTPS desde Internet
resource "aws_security_group" "alb" {
  name        = "${local.name_prefix}-alb-sg"
  description = "Security group for the ALB - allows HTTP/HTTPS from internet"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${local.name_prefix}-alb-sg"
    }
  )
}

# Frontend Security Group - Permite tráfico desde el ALB
resource "aws_security_group" "frontend" {
  name        = "${local.name_prefix}-frontend-sg"
  description = "Security group for the frontend service"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 5173
    to_port         = 5173
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${local.name_prefix}-frontend-sg"
    }
  )
}

# Backend Security Group - Permite tráfico desde el ALB (y opcionalmente desde el frontend)
resource "aws_security_group" "backend" {
  name        = "${local.name_prefix}-backend-sg"
  description = "Security group for the backend service"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from ALB"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${local.name_prefix}-backend-sg"
    }
  )
}

# --- IAM Roles e IAM Policies ---

# ECS Task Execution Role - Para extraer imágenes y enviar logs
resource "aws_iam_role" "ecs_task_execution" {
  name = "${local.name_prefix}-ecs-task-execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Backend Task Role - Para que el contenedor acceda a servicios AWS
resource "aws_iam_role" "backend_task" {
  name = "${local.name_prefix}-backend-task"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })

  tags = var.tags
}

# Política para permitir que el rol de ejecución de tareas lea credenciales de SSM
resource "aws_iam_policy" "ecs_task_execution_ssm_access" {
  name        = "${local.name_prefix}-ecs-task-execution-ssm-access"
  description = "Allow ECS task execution role to access credentials from SSM Parameter Store"
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Action   = [ "ssm:GetParameters", "ssm:GetParameter" ]
      Effect   = "Allow"
      Resource = [
        "arn:aws:ssm:*:*:parameter/${var.project}/${var.environment}/database/*",
        "arn:aws:ssm:*:*:parameter/${var.project}/${var.environment}/api/*"
      ]
    }]
  })
}

# Adjuntar la política SSM al rol de ejecución de tareas
resource "aws_iam_role_policy_attachment" "ecs_task_execution_ssm_access" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecs_task_execution_ssm_access.arn
}