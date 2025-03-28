# ============================================================================
# NETWORKING MODULE - VARIABLES
# ============================================================================
# Este archivo define las variables utilizadas para configurar la infraestructura
# de red, incluyendo VPC, subnets, y zonas de disponibilidad.
# ============================================================================

variable "environment" {
  description = "Entorno de despliegue (develop, staging, production)"
  type        = string
}

variable "project" {
  description = "Nombre del proyecto para etiquetado de recursos"
  type        = string
}

variable "vpc_cidr" {
  description = "Bloque CIDR para la VPC (ej. 10.0.0.0/16)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Bloque CIDR para la subnet pública principal"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Bloque CIDR para la subnet privada (backend)"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "Zona de disponibilidad principal para las subnets"
  type        = string
  default     = "us-west-2a"
}

variable "public_subnet_cidr2" {
  description = "Bloque CIDR para la subnet pública secundaria (requerida por ALB)"
  type        = string
  default     = "10.0.3.0/24"
}

variable "availability_zone2" {
  description = "Zona de disponibilidad secundaria para la segunda subnet pública"
  type        = string
  default     = "us-west-2b"
}

variable "tags" {
  description = "Etiquetas adicionales para todos los recursos"
  type        = map(string)
  default     = {}
}