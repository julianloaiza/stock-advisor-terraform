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