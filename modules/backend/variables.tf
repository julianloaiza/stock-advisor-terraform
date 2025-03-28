# ============================================================================
# BACKEND MODULE - VARIABLES
# ============================================================================
# Este archivo define las variables necesarias para configurar los recursos
# del servicio backend.
# ============================================================================

# ====================== VARIABLES BÁSICAS ======================
variable "environment" {
  description = "Entorno de despliegue (develop, staging, production)"
  type        = string
}

variable "project" {
  description = "Nombre del proyecto para etiquetado de recursos"
  type        = string
}

variable "aws_region" {
  description = "Región AWS donde se desplegarán los recursos"
  type        = string
}

# ====================== VARIABLES DE RECURSOS ======================
variable "task_cpu" {
  description = "Unidades de CPU para la tarea (1024 = 1 vCPU)"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memoria para la tarea en MiB"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Número deseado de tareas para el servicio ECS"
  type        = number
  default     = 1
}

# ====================== VARIABLES DE CONFIGURACIÓN ======================
variable "sync_max_iterations" {
  description = "Número máximo de iteraciones para sincronización de stocks"
  type        = number
  default     = 100
}

variable "sync_timeout" {
  description = "Tiempo de espera en segundos para sincronización"
  type        = number
  default     = 60
}

variable "cors_allowed_origins" {
  description = "Orígenes permitidos para CORS"
  type        = string
  default     = "*"
}

# ====================== REFERENCIAS A OTROS MÓDULOS ======================
# Networking
variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "public_subnet_id" {
  description = "ID de la subnet pública principal"
  type        = string
}

variable "public_subnet_id_2" {
  description = "ID de la subnet pública secundaria"
  type        = string
}

variable "private_subnet_id" {
  description = "ID de la subnet privada donde se ejecutará el servicio ECS"
  type        = string
}

# Security
variable "alb_security_group_id" {
  description = "ID del grupo de seguridad para el ALB"
  type        = string
}

variable "backend_security_group_id" {
  description = "ID del grupo de seguridad para las tareas del backend"
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "ARN del rol de ejecución de tareas ECS"
  type        = string
}

variable "backend_task_role_arn" {
  description = "ARN del rol de tareas para el backend"
  type        = string
}

# Database y API
variable "database_connection_string_arn" {
  description = "ARN del parámetro SSM con la cadena de conexión a la base de datos"
  type        = string
}

variable "stock_api_url_arn" {
  description = "ARN del parámetro SSM con la URL de la API de stocks"
  type        = string
}

variable "stock_auth_tkn_arn" {
  description = "ARN del parámetro SSM con el token de autenticación de la API de stocks"
  type        = string
}

# ECR
variable "ecr_repository_url" {
  description = "URL del repositorio ECR"
  type        = string
}

# Otros
variable "tags" {
  description = "Etiquetas adicionales para recursos"
  type        = map(string)
  default     = {}
}

# Workaround: variable sin uso porque target_group_arn es creado en este mismo módulo
variable "target_group_arn" {
  description = "ARN del grupo de destino del ALB (usado por la dependencia cíclica)"
  type        = string
  default     = ""
}