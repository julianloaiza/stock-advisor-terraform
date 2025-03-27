# modules/database/variables.tf

# Variables para el módulo database

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "connection_string" {
  description = "CockroachDB full connection string"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "Name of the CockroachDB database"
  type        = string
}

variable "database_user" {
  description = "Username for CockroachDB connection"
  type        = string
}

variable "database_region" {
  description = "Region where CockroachDB is hosted"
  type        = string
  default     = "us-west-2"
}

variable "ssl_mode" {
  description = "SSL mode for database connection"
  type        = string
  default     = "verify-full"
}

variable "auto_migrate" {
  description = "Whether to automatically migrate database schema on startup"
  type        = bool
  default     = true
}