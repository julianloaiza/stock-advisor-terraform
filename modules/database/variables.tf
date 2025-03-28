# ============================================================================
# DATABASE MODULE - VARIABLES
# ============================================================================
# Este archivo define las variables necesarias para el módulo de base de datos,
# incluyendo credenciales y configuraciones para CockroachDB y la API externa.
# ============================================================================

variable "environment" {
  description = "Entorno de despliegue (develop, staging, production)"
  type        = string
}

variable "project" {
  description = "Nombre del proyecto para etiquetado de recursos"
  type        = string
}

variable "cockroach_connection_string" {
  description = "Cadena de conexión a CockroachDB (postgresql://user:pass@host:port/dbname?options)"
  type        = string
  sensitive   = true
}

variable "cockroach_ca_cert" {
  description = "Contenido del certificado CA de CockroachDB para conexiones SSL"
  type        = string
  sensitive   = true
  default     = ""  # Opcional para conexiones sin SSL
}

variable "stock_api_url" {
  description = "URL de la API externa para datos de acciones"
  type        = string
}

variable "stock_auth_tkn" {
  description = "Token de autenticación para la API externa de acciones"
  type        = string
  sensitive   = true
}