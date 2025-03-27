# modules/backend/main.tf

# Implementación mínima del módulo backend para LocalStack gratuito
# Enfocada únicamente en Parameter Store para configuración

# Parámetro SSM para la cadena de conexión a la base de datos
resource "aws_ssm_parameter" "backend_database_url" {
  name        = "/${var.environment}/backend/database_url"
  description = "Database connection string for backend service"
  type        = "SecureString"
  value       = var.database_url
}

# Parámetro SSM para almacenar el token de autenticación de la API
resource "aws_ssm_parameter" "stock_auth_token" {
  name        = "/${var.environment}/backend/stock_auth_token"
  description = "Token de autenticación para la API externa de datos de acciones"
  type        = "SecureString"
  value       = var.stock_auth_token
}

# Parámetro SSM para la URL de la API externa de acciones
resource "aws_ssm_parameter" "stock_api_url" {
  name        = "/${var.environment}/backend/stock_api_url"
  description = "URL de la API externa para datos de acciones"
  type        = "String"
  value       = var.stock_api_url
}

# Parámetro SSM para configurar el puerto de la API
resource "aws_ssm_parameter" "api_port" {
  name        = "/${var.environment}/backend/api_port"
  description = "Puerto en el que se ejecuta la API del backend"
  type        = "String"
  value       = tostring(var.api_port)
}

# Parámetro SSM para orígenes CORS permitidos
resource "aws_ssm_parameter" "cors_allowed_origins" {
  name        = "/${var.environment}/backend/cors_allowed_origins"
  description = "Orígenes permitidos para CORS"
  type        = "String"
  value       = var.cors_allowed_origins
}

# Parámetro SSM para máximo de iteraciones en sincronización
resource "aws_ssm_parameter" "sync_max_iterations" {
  name        = "/${var.environment}/backend/sync_max_iterations"
  description = "Número máximo de iteraciones para sincronización de datos"
  type        = "String"
  value       = tostring(var.sync_max_iterations)
}

# Parámetro SSM para timeout de sincronización
resource "aws_ssm_parameter" "sync_timeout" {
  name        = "/${var.environment}/backend/sync_timeout"
  description = "Timeout en segundos para operación de sincronización"
  type        = "String"
  value       = tostring(var.sync_timeout)
}