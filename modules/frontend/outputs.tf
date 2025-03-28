output "s3_bucket_id" {
  description = "The ID of the S3 bucket hosting the frontend"
  value       = aws_s3_bucket.frontend.id
}

output "s3_website_endpoint" {
  description = "The website endpoint URL of the S3 bucket"
  value       = aws_s3_bucket_website_configuration.frontend.website_endpoint
}