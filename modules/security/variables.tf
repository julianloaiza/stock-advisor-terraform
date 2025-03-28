variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project" {
  description = "Project name for resource tagging"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where to create security groups"
  type        = string
}

variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}