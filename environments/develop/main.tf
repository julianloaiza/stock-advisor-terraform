###############################################################################
# Configuración Principal de Terraform para el entorno de desarrollo
###############################################################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

###############################################################################
# Proveedor AWS
# Se configura la región y las credenciales necesarias para interactuar con AWS.
###############################################################################
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

###############################################################################
# Variables Locales
# Se define un bloque local para cargar el certificado CA de CockroachDB y
# se generan etiquetas comunes que se aplicarán a todos los recursos.
###############################################################################
locals {
  cockroach_ca_cert = file("${path.module}/certs/ca_cert.pem")

  # Etiquetas comunes utilizadas para todos los recursos del entorno.
  common_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
  }
}

###############################################################################
# Módulo Database
# Este módulo configura los parámetros en SSM para la conexión segura a CockroachDB
# y para almacenar la URL y token de autenticación para la API de Stock.
###############################################################################
module "database" {
  source = "../../modules/database"

  environment                 = var.environment
  project                     = var.project
  cockroach_connection_string = var.cockroach_connection_string
  cockroach_ca_cert           = local.cockroach_ca_cert
  stock_api_url               = var.stock_api_url
  stock_auth_tkn              = var.stock_auth_tkn
}

###############################################################################
# Módulo Networking
# Se crea la infraestructura de red, incluyendo la VPC, subnets públicas y privadas,
# Internet Gateway, NAT Gateway y tablas de rutas.
###############################################################################
module "networking" {
  source = "../../modules/networking"

  environment         = var.environment
  project             = var.project
  vpc_cidr            = var.vpc_cidr
  availability_zone   = var.availability_zone
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr

  tags = local.common_tags
}

###############################################################################
# Módulo Security
# Se configuran los roles IAM y los Security Groups necesarios para controlar el acceso
# a los recursos, tanto para el backend (ECS y ALB) como para otros componentes.
###############################################################################
module "security" {
  source = "../../modules/security"

  environment = var.environment
  project     = var.project
  vpc_id      = module.networking.vpc_id

  tags = local.common_tags
}

###############################################################################
# Módulo Backend
# Se despliega el servicio del backend:
# - Repositorio de contenedores (ECR)
# - Cluster ECS y Task Definition para ejecutar contenedores en Fargate.
# - Servicio ECS que utiliza un ALB para enrutar tráfico a los contenedores.
###############################################################################
module "backend" {
  source = "../../modules/backend"

  environment = var.environment
  project     = var.project
  aws_region  = var.aws_region

  # Referencias a otros módulos:
  ecr_repository_url             = module.backend.ecr_repository_url
  ecs_task_execution_role_arn    = module.security.ecs_task_execution_role_arn
  backend_task_role_arn          = module.security.backend_task_role_arn
  database_connection_string_arn = module.database.connection_string_param_arn
  stock_api_url_arn              = module.database.stock_api_url_param_arn
  stock_auth_tkn_arn             = module.database.stock_auth_tkn_param_arn

  # Recursos y configuración de la tarea:
  task_cpu    = 256
  task_memory = 512

  # Configuración de networking para el backend:
  alb_security_group_id     = module.security.alb_security_group_id
  public_subnet_id          = module.networking.public_subnet_id
  public_subnet_id_2        = module.networking.public_subnet_id_2
  vpc_id                    = module.networking.vpc_id
  private_subnet_id         = module.networking.private_subnet_id
  backend_security_group_id = module.security.backend_security_group_id
  target_group_arn          = module.backend.target_group_arn
  desired_count             = 1

  tags = local.common_tags
}

###############################################################################
# Módulo Frontend
# Se despliega la infraestructura para alojar el frontend (aplicación estática en S3).
###############################################################################
module "frontend" {
  source = "../../modules/frontend"

  environment = var.environment
  project     = var.project
}
