variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-east-1"  # Cambiar a tu región preferida
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "stock-advisor"
}

# Variables relacionadas con la base de datos
variable "db_username" {
  description = "Database username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_connection_string" {
  description = "CockroachDB connection string"
  type        = string
  sensitive   = true
}

# Variables para el backend
variable "backend_container_port" {
  description = "Port exposed by the backend container"
  type        = number
  default     = 8080
}

variable "backend_cpu" {
  description = "CPU units for the backend container"
  type        = number
  default     = 256
}

variable "backend_memory" {
  description = "Memory for the backend container in MiB"
  type        = number
  default     = 512
}

# Variables para el frontend
variable "frontend_domain" {
  description = "Domain name for the frontend"
  type        = string
  default     = ""
}
