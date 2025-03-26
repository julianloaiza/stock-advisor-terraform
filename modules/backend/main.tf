resource "aws_ssm_parameter" "backend_database_url" {
  name        = "/${var.environment}/backend/database_url"
  description = "Database connection string for backend service"
  type        = "SecureString"
  value       = var.database_url
}