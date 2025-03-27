variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project" {
  description = "Project name for resource tagging"
  type        = string
}

variable "cockroach_connection_string" {
  description = "CockroachDB connection string"
  type        = string
  sensitive   = true
}

variable "cockroach_ca_cert" {
  description = "CockroachDB CA certificate content"
  type        = string
  sensitive   = true
  default     = ""
}