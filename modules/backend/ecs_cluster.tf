# ============================================================================
# BACKEND MODULE - ECS CLUSTER
# ============================================================================
# Este archivo define el cluster ECS y la configuración para los logs
# del servicio backend.
# ============================================================================

# Cluster ECS que albergará los servicios de backend
resource "aws_ecs_cluster" "backend" {
  name = "${var.project}-${var.environment}-cluster"

  # Habilitar Container Insights para monitoreo avanzado
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
  }
}

# Grupo de logs en CloudWatch para centralizar los logs del backend
resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/${var.project}-${var.environment}-backend"
  retention_in_days = 30  # Retención de logs por 30 días

  tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
  }
}