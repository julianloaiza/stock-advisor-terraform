# modules/frontend/outputs.tf

# Outputs del módulo frontend

output "website_url" {
  description = "URL of the S3 hosted website (simulated)"
  value       = "http://${aws_s3_bucket.frontend_bucket.bucket}.s3-website.localhost:4566"
}

output "bucket_name" {
  description = "Name of the S3 bucket hosting the frontend"
  value       = aws_s3_bucket.frontend_bucket.bucket
}

output "backend_api_url_parameter" {
  description = "SSM Parameter containing the backend API URL"
  value       = aws_ssm_parameter.backend_api_url.name
}

output "default_language_parameter" {
  description = "SSM Parameter containing the default language setting"
  value       = aws_ssm_parameter.default_language.name
}

output "frontend_logs_bucket" {
  description = "S3 bucket for frontend logs"
  value       = aws_s3_bucket.frontend_logs.bucket
}

output "module_enabled" {
  description = "Indicates that the frontend module is enabled"
  value       = true
}

output "local_frontend_url" {
  description = "URL for accessing the frontend in local development"
  value       = "http://localhost:${var.frontend_port}"
}