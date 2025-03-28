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

output "database" {
  description = "All database module outputs"
  value = {
    for key, value in module.database : key => value
  }
}
output "networking" {
  description = "All networking module outputs"
  value = {
    for key, value in module.networking : key => value
  }
}
output "security" {
  description = "All security module outputs"
  value = {
    for key, value in module.security : key => value
  }
}