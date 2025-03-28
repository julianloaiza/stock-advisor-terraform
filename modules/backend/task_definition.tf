# ============================================================================
# BACKEND MODULE - TASK DEFINITION
# ============================================================================
# Este archivo define la tarea ECS que ejecutará el contenedor de la
# aplicación backend, incluyendo recursos, variables de entorno y configuración.
# ============================================================================

resource "aws_ecs_task_definition" "backend" {
  family                   = "${var.project}-${var.environment}-backend"
  network_mode             = "awsvpc"                        # Requerido para Fargate
  requires_compatibilities = ["FARGATE"]                    # Usar Fargate (serverless)
  cpu                      = var.task_cpu                    # Unidades de CPU (1024 = 1 vCPU)
  memory                   = var.task_memory                 # Memoria en MB
  execution_role_arn       = var.ecs_task_execution_role_arn # Rol para iniciar tareas
  task_role_arn            = var.backend_task_role_arn       # Rol para la aplicación

  # Definición de contenedores (en formato JSON)
  container_definitions = jsonencode([
    {
      name      = "${var.project}-${var.environment}-backend"
      image     = "${var.ecr_repository_url}:latest"         # Imagen del contenedor
      essential = true                                       # Si falla, la tarea falla
      
      # Mapeo de puertos (contenedor:host)
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
      
      # Variables de entorno públicas
      environment = [
        {
          name  = "ENV"
          value = var.environment
        },
        {
          name  = "ADDRESS"
          value = ":8080"
        },
        {
          name  = "SYNC_MAX_ITERATIONS"
          value = tostring(var.sync_max_iterations)
        },
        {
          name  = "SYNC_TIMEOUT"
          value = tostring(var.sync_timeout)
        },
        {
          name  = "CORS_ALLOWED_ORIGINS"
          value = var.cors_allowed_origins
        }
      ]
      
      # Variables de entorno sensibles (desde SSM Parameter Store)
      secrets = [
        {
          name      = "DATABASE_URL"
          valueFrom = var.database_connection_string_arn
        },
        {
          name      = "STOCK_API_URL"
          valueFrom = var.stock_api_url_arn
        },
        {
          name      = "STOCK_AUTH_TKN"
          valueFrom = var.stock_auth_tkn_arn
        }
      ]
      
      # Configuración de logs
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.backend.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      
      # Verificación de salud del contenedor
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:8080/health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60  # Tiempo para inicialización
      }
    }
  ])

  tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
  }
}