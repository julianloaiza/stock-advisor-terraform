variable "database_connection_string" {
  description = "CockroachDB Serverless connection string"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Deployment environment"
  default     = "dev"
}