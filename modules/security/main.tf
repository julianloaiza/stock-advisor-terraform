# ============================================================================
# SECURITY MODULE - MAIN CONFIGURATION
# ============================================================================
# Este módulo gestiona los aspectos de seguridad de la aplicación, incluyendo
# grupos de seguridad, roles IAM y políticas para los diferentes componentes.
# ============================================================================

locals {
  name_prefix = "${var.project}-${var.environment}"
}

# ======================= GRUPOS DE SEGURIDAD =======================
# ALB Security Group - Permite tráfico HTTP/HTTPS desde Internet
resource "aws_security_group" "alb" {
  name        = "${local.name_prefix}-alb-sg"
  description = "Grupo de seguridad para el ALB - permite HTTP/HTTPS desde Internet"
  vpc_id      = var.vpc_id

  # Regla de ingreso para HTTP
  ingress {
    description = "HTTP desde Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla de ingreso para HTTPS
  ingress {
    description = "HTTPS desde Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regla de egreso - Permite todo el tráfico saliente
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Todos los protocolos
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${local.name_prefix}-alb-sg"
    }
  )
}

# Frontend Security Group - Permite tráfico desde el ALB al servicio frontend
resource "aws_security_group" "frontend" {
  name        = "${local.name_prefix}-frontend-sg"
  description = "Grupo de seguridad para el servicio frontend"
  vpc_id      = var.vpc_id

  # Permite tráfico HTTP desde el ALB al puerto del frontend
  ingress {
    description     = "HTTP desde ALB"
    from_port       = 5173  # Puerto estándar para el servicio frontend Vue.js
    to_port         = 5173
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Permite todo el tráfico saliente
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

# Backend Security Group - Permite tráfico desde el ALB al servicio backend
resource "aws_security_group" "backend" {
  name        = "${local.name_prefix}-backend-sg"
  description = "Grupo de seguridad para el servicio backend"
  vpc_id      = var.vpc_id

  # Permite tráfico HTTP desde el ALB al puerto del backend
  ingress {
    description     = "HTTP desde ALB"
    from_port       = 8080  # Puerto estándar para el servicio backend Go
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  # Permite todo el tráfico saliente
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

# ============================= ROLES IAM =============================
# ECS Task Execution Role - Para que ECS pueda extraer imágenes y enviar logs
resource "aws_iam_role" "ecs_task_execution" {
  name = "${local.name_prefix}-ecs-task-execution"

  # Política de confianza: permite que el servicio ECS asuma este rol
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

# Adjunta la política administrada de AWS para la ejecución de tareas de ECS
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Backend Task Role - Para permisos específicos del contenedor backend
resource "aws_iam_role" "backend_task" {
  name = "${local.name_prefix}-backend-task"

  # Política de confianza: permite que el servicio ECS asuma este rol
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

# ========================= POLÍTICAS IAM =========================
# Política para permitir acceso a parámetros en SSM Parameter Store
resource "aws_iam_policy" "ecs_task_execution_ssm_access" {
  name        = "${local.name_prefix}-ecs-task-execution-ssm-access"
  description = "Permite al rol de ejecución de tareas ECS acceder a credenciales desde SSM Parameter Store"
  
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Action   = ["ssm:GetParameters", "ssm:GetParameter"]
      Effect   = "Allow"
      Resource = [
        "arn:aws:ssm:*:*:parameter/${var.project}/${var.environment}/database/*",
        "arn:aws:ssm:*:*:parameter/${var.project}/${var.environment}/api/*"
      ]
    }]
  })
}

# Adjuntar la política de acceso SSM al rol de ejecución de tareas ECS
resource "aws_iam_role_policy_attachment" "ecs_task_execution_ssm_access" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecs_task_execution_ssm_access.arn
}