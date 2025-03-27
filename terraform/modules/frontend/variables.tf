# modules/frontend/variables.tf

# Variables para el módulo frontend

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "backend_api_url" {
  description = "URL of the backend API"
  type        = string
}

variable "default_language" {
  description = "Default language for the frontend UI (EN or ES)"
  type        = string
  default     = "EN"
  
  validation {
    condition     = contains(["EN", "ES"], var.default_language)
    error_message = "Default language must be either 'EN' or 'ES'."
  }
}

variable "frontend_port" {
  description = "Port on which the frontend will run in local development"
  type        = number
  default     = 5173
}