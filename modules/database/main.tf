resource "aws_ssm_parameter" "cockroach_connection_string" {
  name        = "/${var.project}/${var.environment}/database/connection_string"
  description = "CockroachDB connection string for ${var.environment} environment"
  type        = "SecureString"
  value       = var.cockroach_connection_string
  
  tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

resource "aws_ssm_parameter" "cockroach_ca_cert" {
  name        = "/${var.project}/${var.environment}/database/ca_cert"
  description = "CockroachDB CA certificate for ${var.environment} environment"
  type        = "SecureString"
  value       = var.cockroach_ca_cert
  
  tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}