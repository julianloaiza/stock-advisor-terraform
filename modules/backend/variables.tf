# Este archivo define las variables de entrada específicas para el módulo backend.
# Estas variables permiten personalizar el comportamiento del módulo.

# Variable environment: Entorno de despliegue que se usa en el módulo
variable "environment" {
  description = "Deployment environment"  # Descripción de la variable
  type        = string                    # Tipo de dato (cadena de texto)
}

# Variable database_url: Cadena de conexión a la base de datos
variable "database_url" {
  description = "CockroachDB connection string"  # Descripción de la variable
  type        = string                           # Tipo de dato (cadena de texto)
  sensitive   = true                             # Marca como sensible para no mostrarla en logs
}