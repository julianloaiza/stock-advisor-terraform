variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project" {
  description = "Project name for resource tagging"
  type        = string
}

variable "ecr_repository_url" {
  description = "URL of the ECR repository"
  type        = string
}

variable "task_cpu" {
  description = "CPU units for the task (1024 = 1 vCPU)"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory for the task in MiB"
  type        = number
  default     = 512
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  type        = string
}

variable "backend_task_role_arn" {
  description = "ARN of the backend task role"
  type        = string
}

variable "database_connection_string_arn" {
  description = "ARN of the SSM parameter containing the database connection string"
  type        = string
}

variable "alb_security_group_id" {
  description = "ID of the ALB security group"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet"
  type        = string
}

variable "public_subnet_id_2" {
  description = "ID of the public subnet2"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_id" {
  description = "ID of the private subnet where the ECS service will run"
  type        = string
}

variable "backend_security_group_id" {
  description = "Security Group ID for the backend ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB target group for the ECS service"
  type        = string
}

variable "desired_count" {
  description = "Number of desired tasks for the ECS service"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}
