# modules/database/outputs.tf

# Outputs del módulo database

output "connection_string_parameter" {
  description = "SSM Parameter name for database connection string"
  value       = aws_ssm_parameter.database_url.name
}

output "database_name_parameter" {
  description = "SSM Parameter name for database name"
  value       = aws_ssm_parameter.database_name.name
}

output "database_user_parameter" {
  description = "SSM Parameter name for database user"
  value       = aws_ssm_parameter.database_user.name
}

output "database_region_parameter" {
  description = "SSM Parameter name for database region"
  value       = aws_ssm_parameter.database_region.name
}

output "database_ssl_mode_parameter" {
  description = "SSM Parameter name for database SSL mode"
  value       = aws_ssm_parameter.database_ssl_mode.name
}

output "auto_migrate_parameter" {
  description = "SSM Parameter name for auto-migrate setting"
  value       = aws_ssm_parameter.auto_migrate.name
}

output "module_enabled" {
  description = "Indicates that the database module is enabled"
  value       = true
}