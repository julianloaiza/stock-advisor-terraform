# ============================================================================
# DATABASE MODULE - MAIN CONFIGURATION
# ============================================================================
# Este módulo se encarga de gestionar los parámetros seguros para el acceso a
# la base de datos y credenciales de API en AWS SSM Parameter Store.
# No despliega una base de datos en sí, sino que gestiona sus credenciales.
# ============================================================================

# ============================ DATABASE CREDENTIALS ===========================
# Almacena la cadena de conexión a CockroachDB como parámetro seguro en AWS SSM
resource "aws_ssm_parameter" "cockroach_connection_string" {
  name        = "/${var.project}/${var.environment}/database/connection_string"
  description = "CockroachDB connection string for ${var.environment} environment"
  type        = "SecureString"  # Cifrado usando la clave KMS por defecto de AWS
  value       = var.cockroach_connection_string
  
  tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
    Component   = "database"
  }
}

# Almacena el certificado CA de CockroachDB como parámetro seguro
# Esto es necesario para conexiones SSL con verificación de certificado
resource "aws_ssm_parameter" "cockroach_ca_cert" {
  name        = "/${var.project}/${var.environment}/database/ca_cert"
  description = "CockroachDB CA certificate for ${var.environment} environment"
  type        = "SecureString"
  value       = var.cockroach_ca_cert
  
  tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
    Component   = "database"
  }
}

# ============================== API CREDENTIALS =============================
# Almacena la URL de la API externa de datos de acciones
# No se considera dato sensible, por lo que se almacena como String normal
resource "aws_ssm_parameter" "stock_api_url" {
  name        = "/${var.project}/${var.environment}/api/stock_api_url"
  description = "Stock API URL for ${var.environment} environment"
  type        = "String"
  value       = var.stock_api_url
  
  tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
    Component   = "api"
  }
}

# Almacena el token de autenticación para la API externa como parámetro seguro
resource "aws_ssm_parameter" "stock_auth_tkn" {
  name        = "/${var.project}/${var.environment}/api/stock_auth_tkn"
  description = "Stock Auth Token for ${var.environment} environment"
  type        = "SecureString"  # Cifrado usando la clave KMS por defecto de AWS
  value       = var.stock_auth_tkn
  
  tags = {
    Environment = var.environment
    Project     = var.project
    Terraform   = "true"
    Component   = "api"
  }
}