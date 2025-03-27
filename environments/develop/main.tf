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
}


# Módulo de base de datos para gestionar la conexión a CockroachDB
module "database" {
  source = "../../modules/database"

  environment                 = var.environment
  project                     = var.project
  cockroach_connection_string = var.cockroach_connection_string
  cockroach_ca_cert           = local.cockroach_ca_cert
}