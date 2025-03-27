# Este archivo define los recursos específicos del módulo backend.
# Encapsula la lógica relacionada con el servicio de backend.

# Recurso aws_ssm_parameter: Crea un parámetro en SSM específico para el servicio backend
# Este parámetro almacenará la cadena de conexión a la base de datos para que el backend pueda acceder a ella
resource "aws_ssm_parameter" "backend_database_url" {
  name        = "/${var.environment}/backend/database_url"   # Ruta jerárquica (ej: /dev/backend/database_url)
  description = "Database connection string for backend service"  # Descripción humanamente legible
  type        = "SecureString"            # Tipo seguro (cifrado) para datos sensibles
  value       = var.database_url          # Valor del parámetro (cadena de conexión)
}