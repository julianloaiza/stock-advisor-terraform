# variables.tf (actualizado con nuevas variables para el módulo database)

variable "database_connection_string" {
  description = "CockroachDB Serverless connection string"
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^postgresql://", var.database_connection_string))
    error_message = "La cadena de conexión debe comenzar con 'postgresql://'."
  }
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "stock_api_url" {
  description = "URL de la API externa para datos de acciones"
  type        = string
  default     = "https://8j5baasof2.execute-api.us-west-2.amazonaws.com/production/swechallenge/list"
}

variable "stock_auth_token" {
  description = "Token de autenticación para la API externa de datos de acciones"
  type        = string
  sensitive   = true
}

variable "backend_port" {
  description = "Puerto en el que se ejecutará el servicio backend"
  type        = number
  default     = 8080
}

variable "frontend_port" {
  description = "Puerto en el que se ejecutará el servicio frontend"
  type        = number
  default     = 5173
}

variable "default_language" {
  description = "Idioma predeterminado para la interfaz de usuario (EN o ES)"
  type        = string
  default     = "EN"
  
  validation {
    condition     = contains(["EN", "ES"], var.default_language)
    error_message = "El idioma predeterminado debe ser 'EN' o 'ES'."
  }
}

variable "cors_allowed_origins" {
  description = "Lista de orígenes permitidos para CORS (separados por comas)"
  type        = string
  default     = "*"
}

variable "sync_max_iterations" {
  description = "Número máximo de iteraciones para sincronización de datos de acciones"
  type        = number
  default     = 100
}

variable "sync_timeout" {
  description = "Timeout en segundos para la operación de sincronización"
  type        = number
  default     = 60
}

variable "database_region" {
  description = "Región donde se encuentra la base de datos CockroachDB"
  type        = string
  default     = "us-west-2"
}

variable "database_ssl_mode" {
  description = "Modo SSL para la conexión a la base de datos"
  type        = string
  default     = "verify-full"
}

variable "auto_migrate" {
  description = "Si se debe migrar automáticamente el esquema de la base de datos al inicio"
  type        = bool
  default     = true
}