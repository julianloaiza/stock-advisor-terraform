# ============================================================================
# SECURITY MODULE - VARIABLES
# ============================================================================
# Este archivo define las variables necesarias para configurar los aspectos
# de seguridad de la aplicación, incluyendo grupos de seguridad y roles IAM.
# ============================================================================

variable "environment" {
  description = "Entorno de despliegue (develop, staging, production)"
  type        = string
}

variable "project" {
  description = "Nombre del proyecto para etiquetado de recursos"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC donde se crearán los grupos de seguridad"
  type        = string
}

variable "tags" {
  description = "Etiquetas adicionales para todos los recursos"
  type        = map(string)
  default     = {}
}