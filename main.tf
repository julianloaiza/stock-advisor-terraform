# Este archivo es el punto de entrada principal para la configuración de Terraform.
# Define los proveedores, recursos base y orquesta la creación de infraestructura.

# Bloque terraform: Define la configuración básica de Terraform y sus dependencias
terraform {
  # Especifica los proveedores externos requeridos y sus versiones
  required_providers {
    aws = {
      source  = "hashicorp/aws" # Ubicación del proveedor en el registro de Terraform
      version = "~> 4.0"        # Restringe a versiones 4.x.x (permite actualizaciones menores)
    }
  }
}

# Bloque provider: Configura cómo Terraform interactúa con AWS
provider "aws" {
  region                      = "us-east-1" # Región AWS simulada (irrelevante para LocalStack)
  access_key                  = "test"      # Credenciales ficticias para LocalStack
  secret_key                  = "test"      # Credenciales ficticias para LocalStack
  skip_credentials_validation = true        # Evita validar credenciales (necesario para LocalStack)
  skip_metadata_api_check     = true        # Omite verificación de metadatos de instancia EC2
  skip_requesting_account_id  = true        # Omite la solicitud de ID de cuenta AWS

  # Redirecciona todas las llamadas a la API de AWS a LocalStack
  # endpoints: Define URLs alternativas para servicios AWS
  endpoints {
    rds                  = "http://localhost:4566" # Servicio de bases de datos
    ecr                  = "http://localhost:4566" # Registro de contenedores
    ecs                  = "http://localhost:4566" # Servicio de contenedores
    elasticloadbalancing = "http://localhost:4566" # Balanceadores de carga
    ec2                  = "http://localhost:4566" # Instancias de cómputo
    ssm                  = "http://localhost:4566" # Systems Manager (Parameter Store)
  }
}

# Bloque module: Inicializa el módulo para el componente backend
# Los módulos son unidades reutilizables que encapsulan grupos de recursos
module "backend" {
  source       = "./modules/backend"            # Ubicación del código del módulo
  environment  = var.environment                # Pasa el entorno (dev, prod) al módulo
  database_url = var.database_connection_string # Pasa la cadena de conexión al módulo
}

# Output backend_database_param_name: Expone el nombre del parámetro SSM del backend como salida
output "backend_database_param_name" {
  value       = module.backend.database_parameter_name
  description = "Nombre del parámetro SSM que contiene la URL de la base de datos para el backend"
}

# Output environment: Expone el entorno actual como salida
output "environment" {
  value       = var.environment
  description = "Entorno actual de despliegue"
}

# Output backend_module_enabled: Indica si el módulo de backend está habilitado
output "backend_module_enabled" {
  value       = module.backend.module_enabled
  description = "Indica si el módulo de backend está habilitado"
}

# Output database_region: Expone la región de la base de datos
output "database_region" {
  value       = "us-west-2"
  description = "Región donde se encuentra la base de datos CockroachDB"
}