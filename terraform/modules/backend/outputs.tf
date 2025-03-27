# modules/backend/outputs.tf

# Outputs simplificados del módulo backend

output "database_parameter_name" {
  description = "SSM Parameter name containing the database connection string"
  value       = aws_ssm_parameter.backend_database_url.name
}

output "database_parameter_arn" {
  description = "ARN of the SSM Parameter containing database connection string"
  value       = aws_ssm_parameter.backend_database_url.arn
}

output "stock_api_url_parameter_name" {
  description = "SSM Parameter name containing the stock API URL"
  value       = aws_ssm_parameter.stock_api_url.name
}

output "stock_auth_token_parameter_name" {
  description = "SSM Parameter name containing the stock API auth token"
  value       = aws_ssm_parameter.stock_auth_token.name
}

output "api_port_parameter_name" {
  description = "SSM Parameter name containing the API port"
  value       = aws_ssm_parameter.api_port.name
}

output "cors_parameter_name" {
  description = "SSM Parameter name containing CORS configuration"
  value       = aws_ssm_parameter.cors_allowed_origins.name
}

output "sync_config_parameters" {
  description = "SSM Parameter names for sync configuration"
  value = {
    max_iterations = aws_ssm_parameter.sync_max_iterations.name
    timeout        = aws_ssm_parameter.sync_timeout.name
  }
}

output "logs_bucket" {
  description = "S3 bucket for backend logs"
  value       = aws_s3_bucket.backend_logs.bucket
}

output "sync_tracking_table" {
  description = "DynamoDB table for sync tracking"
  value       = aws_dynamodb_table.sync_tracking.name
}

output "module_enabled" {
  description = "Indicates that the backend module is enabled"
  value       = true
}

output "backend_service_url" {
  description = "Simulated URL for the backend service (for integration with docker-compose)"
  value       = "http://localhost:${var.api_port}"
}