# modules/database/main.tf

# Módulo para gestionar la configuración de la base de datos CockroachDB
# Como estamos usando una base de datos externa, este módulo principalmente
# se encarga de almacenar la configuración y hacerla disponible para otros servicios

# Parámetro SSM para la cadena de conexión principal
resource "aws_ssm_parameter" "database_url" {
  name        = "/${var.environment}/database/connection_string"
  description = "CockroachDB connection string"
  type        = "SecureString"
  value       = var.connection_string
}

# Parámetro SSM para el nombre de la base de datos
resource "aws_ssm_parameter" "database_name" {
  name        = "/${var.environment}/database/name"
  description = "CockroachDB database name"
  type        = "String"
  value       = var.database_name
}

# Parámetro SSM para el usuario de la base de datos
resource "aws_ssm_parameter" "database_user" {
  name        = "/${var.environment}/database/user"
  description = "CockroachDB user"
  type        = "String"
  value       = var.database_user
}

# Parámetro SSM para la región de la base de datos
resource "aws_ssm_parameter" "database_region" {
  name        = "/${var.environment}/database/region"
  description = "CockroachDB region"
  type        = "String"
  value       = var.database_region
}

# Parámetro SSM para el modo SSL de la base de datos
resource "aws_ssm_parameter" "database_ssl_mode" {
  name        = "/${var.environment}/database/ssl_mode"
  description = "CockroachDB SSL mode"
  type        = "String"
  value       = var.ssl_mode
}

# Parámetro SSM para la configuración de migración automática
resource "aws_ssm_parameter" "auto_migrate" {
  name        = "/${var.environment}/database/auto_migrate"
  description = "Whether to auto-migrate database schema on startup"
  type        = "String"
  value       = var.auto_migrate ? "true" : "false"
}