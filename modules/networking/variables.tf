variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project" {
  description = "Project name for resource tagging"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
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

variable "availability_zone" {
  description = "Availability zone for the main subnets"
  type        = string
  default     = "us-west-2a"
}

variable "public_subnet_cidr2" {
  description = "CIDR block for the secondary public subnet (needed by ALB)"
  type        = string
  default     = "10.0.3.0/24"
}

variable "availability_zone2" {
  description = "Another AZ for the second public subnet"
  type        = string
  default     = "us-west-2b"
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}
