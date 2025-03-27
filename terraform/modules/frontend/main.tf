# modules/frontend/main.tf

# Implementación mínima del módulo frontend para LocalStack gratuito
# Enfocada únicamente en Parameter Store para configuración

# Parámetro SSM para la URL del backend API
resource "aws_ssm_parameter" "backend_api_url" {
  name        = "/${var.environment}/frontend/backend_api_url"
  description = "URL of the backend API for frontend configuration"
  type        = "String"
  value       = var.backend_api_url
}

# Parámetro SSM para el idioma predeterminado
resource "aws_ssm_parameter" "default_language" {
  name        = "/${var.environment}/frontend/default_language"
  description = "Default language for the frontend UI"
  type        = "String"
  value       = var.default_language
}

# Parámetro SSM para el puerto frontend
resource "aws_ssm_parameter" "frontend_port" {
  name        = "/${var.environment}/frontend/port"
  description = "Port for the frontend service"
  type        = "String"
  value       = tostring(var.frontend_port)
}