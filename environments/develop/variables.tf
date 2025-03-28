###############################################################################
# Variables Generales y de Credenciales
###############################################################################

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "aws_access_key" {
  description = "AWS access key for terraform-user"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key for terraform-user"
  type        = string
  sensitive   = true
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "develop"
}

variable "project" {
  description = "Project name for resource tagging"
  type        = string
  default     = "stock-advisor"
}

###############################################################################
# Variables para el Módulo Database
###############################################################################

variable "cockroach_connection_string" {
  description = "CockroachDB connection string"
  type        = string
  sensitive   = true
  # Sin default para obligar a definirlo en un tfvars o manualmente
}

# En environments/develop/variables.tf
variable "stock_api_url" {
  description = "Stock API URL for external data"
  type        = string
  default     = "https://8j5baasof2.execute-api.us-west-2.amazonaws.com/production/swechallenge/list"
}

variable "stock_auth_tkn" {
  description = "Authentication token for Stock API"
  type        = string
  sensitive   = true
}

variable "sync_max_iterations" {
  description = "Maximum number of iterations for stock synchronization"
  type        = number
  default     = 100
}

variable "sync_timeout" {
  description = "Timeout in seconds for stock synchronization"
  type        = number
  default     = 60
}

variable "cors_allowed_origins" {
  description = "Allowed origins for CORS"
  type        = string
  default     = "*"
}

###############################################################################
# Variables para el Módulo Networking
###############################################################################

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zone" {
  description = "Primary Availability zone"
  type        = string
  default     = "us-west-2a"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the primary public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone2" {
  description = "Secondary AZ for the second public subnet (needed by ALB)"
  type        = string
  default     = "us-west-2b"
}

variable "public_subnet_cidr2" {
  description = "CIDR block for the secondary public subnet"
  type        = string
  default     = "10.0.3.0/24"
}

###############################################################################
# Variables de Tagging
###############################################################################

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}
