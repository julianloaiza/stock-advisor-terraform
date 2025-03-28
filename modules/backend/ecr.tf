# ============================================================================
# BACKEND MODULE - ECR (Elastic Container Registry)
# ============================================================================
# Este archivo define el repositorio ECR para almacenar las imágenes Docker
# del servicio backend.
# ============================================================================

resource "aws_ecr_repository" "backend" {
  name                 = "${var.project}-${var.environment}-backend"
  image_tag_mutability = "MUTABLE"  # Permite sobrescribir tags (ej. "latest")
  force_delete         = true

  # Configuración de escaneo automático de vulnerabilidades
  image_scanning_configuration {
    scan_on_push = true  # Escanea imágenes automáticamente al hacer push
  }

  tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
  }
}