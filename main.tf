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

# Guardar información de la base de datos en SSM Parameter Store simulado en LocalStack
resource "aws_ssm_parameter" "database_url" {
  name  = "/${var.environment}/database/url"
  type  = "SecureString"
  value = var.database_connection_string
}

# Output para verificar la creación (no mostrará el valor por ser sensitivo)
output "database_param_name" {
  value = aws_ssm_parameter.database_url.name
}

module "backend" {
  source       = "./modules/backend"
  environment  = var.environment
  database_url = var.database_connection_string
}