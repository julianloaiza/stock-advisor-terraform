# main.tf (modificado para incluir el módulo database)

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ssm                  = "http://localhost:4566"
  }
}

# Extraer nombre de base de datos y usuario de la cadena de conexión
locals {
  # Uso de expresiones regulares para extraer partes de la cadena de conexión
  db_parts = regex("^postgresql://([^:]+)(?::([^@]+))?@([^:]+):([0-9]+)/([^?]+)", var.database_connection_string)
  
  database_user = local.db_parts[0]
  database_name = local.db_parts[4]
}

# Módulo database
module "database" {
  source            = "./modules/database"
  environment       = var.environment
  connection_string = var.database_connection_string
  database_name     = local.database_name
  database_user     = local.database_user
  database_region   = var.database_region
  ssl_mode          = var.database_ssl_mode
  auto_migrate      = var.auto_migrate
}

# Módulo backend (ahora obtiene la cadena de conexión desde el módulo database)
module "backend" {
  source              = "./modules/backend"
  environment         = var.environment
  database_url        = var.database_connection_string
  stock_api_url       = var.stock_api_url
  stock_auth_token    = var.stock_auth_token
  api_port            = var.backend_port
  cors_allowed_origins = var.cors_allowed_origins
  sync_max_iterations = var.sync_max_iterations
  sync_timeout        = var.sync_timeout
}

# Módulo frontend
module "frontend" {
  source           = "./modules/frontend"
  environment      = var.environment
  backend_api_url  = "http://localhost:${var.backend_port}"
  default_language = var.default_language
  frontend_port    = var.frontend_port
}

# Parámetro SSM para la comunicación entre Docker y LocalStack
resource "aws_ssm_parameter" "localstack_host" {
  name        = "/${var.environment}/infrastructure/localstack_host"
  description = "Hostname para acceder a LocalStack desde Docker"
  type        = "String"
  value       = "host.docker.internal"
}

# Parámetro SSM para indicar que la infraestructura está lista
resource "aws_ssm_parameter" "infrastructure_ready" {
  name        = "/${var.environment}/infrastructure/ready"
  description = "Indica que la infraestructura está lista para ser usada"
  type        = "String"
  value       = "true"
  depends_on  = [module.database, module.backend, module.frontend]
}

# Outputs
output "database_parameters" {
  value = {
    connection_string = module.database.connection_string_parameter
    database_name     = module.database.database_name_parameter
    database_user     = module.database.database_user_parameter
    database_region   = module.database.database_region_parameter
    ssl_mode          = module.database.database_ssl_mode_parameter
    auto_migrate      = module.database.auto_migrate_parameter
  }
  description = "Parámetros SSM para la base de datos"
}

output "backend_parameters" {
  value = {
    database_url      = module.backend.database_parameter_name
    stock_api_url     = module.backend.stock_api_url_parameter_name
    stock_auth_token  = module.backend.stock_auth_token_parameter_name
    api_port          = module.backend.api_port_parameter_name
    cors_origins      = module.backend.cors_parameter_name
  }
  description = "Parámetros SSM para el backend"
}

output "frontend_parameters" {
  value = {
    backend_api_url   = module.frontend.backend_api_url_parameter
    default_language  = module.frontend.default_language_parameter
    frontend_port     = module.frontend.frontend_port_parameter
  }
  description = "Parámetros SSM para el frontend"
}

output "infrastructure_status" {
  value       = aws_ssm_parameter.infrastructure_ready.value
  description = "Estado de la infraestructura"
}