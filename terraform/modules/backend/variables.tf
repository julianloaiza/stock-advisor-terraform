# modules/backend/variables.tf

# Variables simplificadas para el módulo backend

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "database_url" {
  description = "Database connection string for backend service"
  type        = string
  sensitive   = true
}

variable "stock_api_url" {
  description = "URL of the external stock data API"
  type        = string
}

variable "stock_auth_token" {
  description = "Authentication token for the external stock API"
  type        = string
  sensitive   = true
}

variable "api_port" {
  description = "Port on which the backend API will run"
  type        = number
  default     = 8080
}

variable "cors_allowed_origins" {
  description = "Comma-separated list of origins allowed for CORS"
  type        = string
  default     = "*"
}

variable "sync_max_iterations" {
  description = "Maximum number of iterations for stock data synchronization"
  type        = number
  default     = 100
}

variable "sync_timeout" {
  description = "Timeout in seconds for stock synchronization operation"
  type        = number
  default     = 60
}