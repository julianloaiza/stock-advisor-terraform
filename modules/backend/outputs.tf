output "database_parameter_name" {
  description = "SSM Parameter name containing the database connection string"
  value       = aws_ssm_parameter.backend_database_url.name
}

output "database_parameter_arn" {
  description = "ARN of the SSM Parameter containing database connection string"
  value       = aws_ssm_parameter.backend_database_url.arn
}

# Estos outputs serán útiles en la Fase 3 cuando implementemos el backend completo
output "module_enabled" {
  description = "Indicates if the backend module is enabled"
  value       = true
}