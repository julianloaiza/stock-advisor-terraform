# environments/develop/variables.tf

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2" # Coincide con la región de CockroachDB
}

variable "aws_access_key" {
  description = "AWS access key for terraform-user"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key for terraform-user"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "develop"
}

variable "project" {
  description = "Project name for resource tagging"
  type        = string
  default     = "stock-advisor"
}

# Database variables
variable "cockroach_connection_string" {
  description = "CockroachDB connection string"
  type        = string
  sensitive   = true
  # No default value for security reasons
}