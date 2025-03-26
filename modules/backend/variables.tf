variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "database_url" {
  description = "CockroachDB connection string"
  type        = string
  sensitive   = true
}