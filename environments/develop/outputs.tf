# environments/develop/outputs.tf

output "aws_region" {
  description = "The AWS region used"
  value       = var.aws_region
}

output "environment" {
  description = "The environment (develop, staging, production)"
  value       = var.environment
}

output "project" {
  description = "The project name"
  value       = var.project
}

# No mostramos las credenciales en los outputs por seguridad
output "aws_access_key_used" {
  description = "Confirmation that AWS access key is being used"
  value       = var.aws_access_key != null ? "Access key configured" : "No access key provided"
  sensitive   = true
}