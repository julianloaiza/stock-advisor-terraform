# ============================================================================
# FRONTEND MODULE - OUTPUTS
# ============================================================================
# Este archivo define las salidas del módulo de frontend, proporcionando
# información sobre el bucket S3 y la URL del sitio web para uso en otros
# módulos o para referencia después del despliegue.
# ============================================================================

output "s3_bucket_id" {
  description = "ID del bucket S3 que aloja el frontend"
  value       = aws_s3_bucket.frontend.id
}

output "s3_bucket_arn" {
  description = "ARN del bucket S3 que aloja el frontend"
  value       = aws_s3_bucket.frontend.arn
}

output "s3_bucket_domain_name" {
  description = "Nombre de dominio del bucket S3"
  value       = aws_s3_bucket.frontend.bucket_domain_name
}

output "website_endpoint" {
  description = "URL del endpoint del sitio web estático S3"
  value       = aws_s3_bucket_website_configuration.frontend.website_endpoint
}

output "website_domain" {
  description = "Dominio del sitio web estático S3"
  value       = aws_s3_bucket_website_configuration.frontend.website_domain
}

output "bucket_regional_domain_name" {
  description = "Nombre de dominio regional del bucket para uso con CloudFront"
  value       = aws_s3_bucket.frontend.bucket_regional_domain_name
}