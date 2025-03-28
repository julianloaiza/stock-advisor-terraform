# environments/develop/main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

locals {
  cockroach_ca_cert = file("${path.module}/certs/ca_cert.pem")

  # Tags comunes para los recursos creados en este entorno
  common_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
  }
}


# Módulo de base de datos para gestionar la conexión a CockroachDB
module "database" {
  source = "../../modules/database"

  environment                 = var.environment
  project                     = var.project
  cockroach_connection_string = var.cockroach_connection_string
  cockroach_ca_cert           = local.cockroach_ca_cert
  stock_api_url               = var.stock_api_url
  stock_auth_tkn              = var.stock_auth_tkn
}

# Módulo de networking para crear la infraestructura de red
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

# Módulo de seguridad para crear grupos de seguridad y roles IAM
module "security" {
  source = "../../modules/security"

  environment = var.environment
  project     = var.project
  vpc_id      = module.networking.vpc_id

  tags = local.common_tags
}

# Módulo Backend
module "backend" {
  source = "../../modules/backend"

  environment                    = var.environment
  project                        = var.project
  aws_region                     = var.aws_region
  ecr_repository_url             = module.backend.ecr_repository_url
  ecs_task_execution_role_arn    = module.security.ecs_task_execution_role_arn
  backend_task_role_arn          = module.security.backend_task_role_arn
  database_connection_string_arn = module.database.connection_string_param_arn
  stock_api_url_arn              = module.database.stock_api_url_param_arn
  stock_auth_tkn_arn             = module.database.stock_auth_tkn_param_arn

  task_cpu    = 256
  task_memory = 512

  alb_security_group_id = module.security.alb_security_group_id
  public_subnet_id      = module.networking.public_subnet_id
  public_subnet_id_2    = module.networking.public_subnet_id_2
  vpc_id                = module.networking.vpc_id

  private_subnet_id         = module.networking.private_subnet_id
  backend_security_group_id = module.security.backend_security_group_id
  target_group_arn          = module.backend.target_group_arn
  desired_count             = 1

  tags = local.common_tags
}


# Módulo Frontend
module "frontend" {
  source = "../../modules/frontend"

  environment = var.environment
  project     = var.project
}