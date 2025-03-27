# Este archivo define las variables de entrada que utiliza la configuración de Terraform.
# Las variables permiten personalizar la infraestructura sin modificar el código.

# Variable database_connection_string: Cadena de conexión a la base de datos
variable "database_connection_string" {
  description = "CockroachDB Serverless connection string" # Descripción de la variable
  type        = string                                     # Tipo de dato (cadena de texto)
  sensitive   = true                                       # Marca como sensible para no mostrarla en logs

  # Validación para asegurar que la cadena tiene el formato correcto
  validation {
    condition     = can(regex("^postgresql://", var.database_connection_string)) # Verifica que comienza con "postgresql://"
    error_message = "La cadena de conexión debe comenzar con 'postgresql://'."   # Mensaje de error si no cumple la condición
  }
}

# Variable environment: Entorno de despliegue (desarrollo, producción, etc.)
variable "environment" {
  description = "Deployment environment" # Descripción de la variable
  default     = "dev"                    # Valor predeterminado si no se especifica
}