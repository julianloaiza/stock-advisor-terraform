###############################################################################
# Outputs del Entorno de Desarrollo
# Estos outputs proporcionan información útil sobre la infraestructura desplegada.
###############################################################################

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

###############################################################################
# Outputs de Módulos
# Se agrupan y muestran todos los outputs relevantes de cada módulo para consulta.
###############################################################################

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

output "backend" {
  description = "All backend module outputs"
  value = {
    for key, value in module.backend : key => value
  }
}

output "frontend" {
  description = "All frontend module outputs"
  value = {
    for key, value in module.frontend : key => value
  }
}
