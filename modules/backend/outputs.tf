# Este archivo define los valores de salida del módulo backend.
# Los outputs pueden ser utilizados por el módulo principal o por otros módulos.

# Output database_parameter_name: Nombre del parámetro SSM creado
output "database_parameter_name" {
  description = "SSM Parameter name containing the database connection string"  # Descripción del output
  value       = aws_ssm_parameter.backend_database_url.name                     # Valor del output (nombre del parámetro)
}

# Output database_parameter_arn: ARN (Amazon Resource Name) del parámetro SSM
output "database_parameter_arn" {
  description = "ARN of the SSM Parameter containing database connection string"  # Descripción del output
  value       = aws_ssm_parameter.backend_database_url.arn                        # Valor del output (ARN del parámetro)
}

# Output module_enabled: Indicador simple de que el módulo está activo
# Este output será útil en la Fase 3 para verificar la activación del módulo
output "module_enabled" {
  description = "Indicates if the backend module is enabled"  # Descripción del output
  value       = true                                          # Valor del output (siempre true)
}