# main.tf
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

  # Usar LocalStack como endpoint
  endpoints {
    rds       = "http://localhost:4566"
    ecr       = "http://localhost:4566"
    ecs       = "http://localhost:4566"
    elasticloadbalancing = "http://localhost:4566"
    ec2       = "http://localhost:4566"
  }
}

# Variables
variable "environment" {
  description = "Deployment environment"
  default     = "dev"
}

# Módulos - se activarán en fases posteriores
# module "database" {
#   source = "./modules/database"
#   environment = var.environment
# }