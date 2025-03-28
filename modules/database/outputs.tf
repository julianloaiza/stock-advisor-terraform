# ============================================================================
# DATABASE MODULE - OUTPUTS
# ============================================================================
# Este archivo define las salidas del módulo de base de datos, proporcionando
# acceso a los ARN y nombres de los parámetros SSM creados para su uso en
# otros módulos de Terraform, especialmente el módulo de backend.
# ============================================================================

# ========================= DATABASE CREDENTIALS OUTPUTS =========================
output "connection_string_param_name" {
  description = "Nombre del parámetro SSM para la cadena de conexión a la base de datos"
  value       = aws_ssm_parameter.cockroach_connection_string.name
}

output "connection_string_param_arn" {
  description = "ARN del parámetro SSM para la cadena de conexión a la base de datos"
  value       = aws_ssm_parameter.cockroach_connection_string.arn
}

output "ca_cert_param_name" {
  description = "Nombre del parámetro SSM para el certificado CA de la base de datos"
  value       = aws_ssm_parameter.cockroach_ca_cert.name
}

output "ca_cert_param_arn" {
  description = "ARN del parámetro SSM para el certificado CA de la base de datos"
  value       = aws_ssm_parameter.cockroach_ca_cert.arn
}

# =========================== API CREDENTIALS OUTPUTS ===========================
output "stock_api_url_param_name" {
  description = "Nombre del parámetro SSM para la URL de la API de acciones"
  value       = aws_ssm_parameter.stock_api_url.name
}

output "stock_api_url_param_arn" {
  description = "ARN del parámetro SSM para la URL de la API de acciones"
  value       = aws_ssm_parameter.stock_api_url.arn
}

output "stock_auth_tkn_param_name" {
  description = "Nombre del parámetro SSM para el token de autenticación de la API de acciones"
  value       = aws_ssm_parameter.stock_auth_tkn.name
}

output "stock_auth_tkn_param_arn" {
  description = "ARN del parámetro SSM para el token de autenticación de la API de acciones"
  value       = aws_ssm_parameter.stock_auth_tkn.arn
}