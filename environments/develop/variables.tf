#######################################################################
# Credenciales e información general
#######################################################################
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

#######################################################################
# Database variables
#######################################################################
variable "cockroach_connection_string" {
  description = "CockroachDB connection string"
  type        = string
  sensitive   = true
  # sin default para obligar a definirlo en un tfvars o manualmente
}

#######################################################################
# Networking variables (manteniendo la esencia)
#######################################################################
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

#######################################################################
# Tagging general
#######################################################################
variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}
