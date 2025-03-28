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

# In modules/database/main.tf (or create a new module for API credentials)
resource "aws_ssm_parameter" "stock_api_url" {
  name        = "/${var.project}/${var.environment}/api/stock_api_url"
  description = "Stock API URL for ${var.environment} environment"
  type        = "String"
  value       = var.stock_api_url
  
  tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}

resource "aws_ssm_parameter" "stock_auth_tkn" {
  name        = "/${var.project}/${var.environment}/api/stock_auth_tkn"
  description = "Stock Auth Token for ${var.environment} environment"
  type        = "SecureString"
  value       = var.stock_auth_tkn
  
  tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
  }
}