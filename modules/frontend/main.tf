# ============================================================================
# FRONTEND MODULE - MAIN CONFIGURATION
# ============================================================================
# Este módulo se encarga de desplegar la infraestructura necesaria para servir
# la aplicación frontend, implementando un sitio web estático alojado en S3.
# ============================================================================

# ============================ BUCKET CONFIGURATION ===========================
# Bucket S3 para alojar los archivos estáticos del frontend
resource "aws_s3_bucket" "frontend" {
  bucket = "${var.project}-${var.environment}-frontend"
  force_destroy = true

  tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
    Component   = "frontend"
  }
}

# Configuración de sitio web estático para el bucket S3
# Esto permite servir una Single Page Application (SPA)
resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  # Para SPA - todas las rutas redirigen a index.html
  error_document {
    key = "index.html"
  }
}

# ========================= PUBLIC ACCESS CONFIGURATION ======================
# Desbloquear acceso público al bucket para servir el sitio web
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Política para permitir lectura pública del contenido del bucket
resource "aws_s3_bucket_policy" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  # Política que permite acceso público de lectura a los objetos del bucket
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })

  # Esperar a que la configuración de acceso público se aplique primero
  depends_on = [aws_s3_bucket_public_access_block.frontend]
}

# ======================== CORS CONFIGURATION ================================
# Configuración CORS para permitir solicitudes desde el dominio del frontend
resource "aws_s3_bucket_cors_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = var.cors_allowed_origins
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}