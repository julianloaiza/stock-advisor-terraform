# ============================================================================
# FRONTEND MODULE - VARIABLES
# ============================================================================
# Este archivo define las variables necesarias para el módulo de frontend,
# incluyendo configuraciones básicas y opciones de CORS.
# ============================================================================

variable "environment" {
  description = "Entorno de despliegue (develop, staging, production)"
  type        = string
}

variable "project" {
  description = "Nombre del proyecto para etiquetado de recursos"
  type        = string
}

variable "cors_allowed_origins" {
  description = "Lista de orígenes permitidos para CORS"
  type        = list(string)
  default     = ["*"]
}

variable "frontend_name" {
  description = "Nombre personalizado para el frontend (opcional)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags adicionales para todos los recursos"
  type        = map(string)
  default     = {}
}