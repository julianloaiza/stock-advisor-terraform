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
  default     = "dev"
}