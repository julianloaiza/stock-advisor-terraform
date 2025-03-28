output "s3_bucket_id" {
  description = "The ID of the S3 bucket hosting the frontend"
  value       = aws_s3_bucket.frontend.id
}

output "s3_website_endpoint" {
  description = "The website endpoint URL of the S3 bucket"
  value       = aws_s3_bucket_website_configuration.frontend.website_endpoint
}

output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.frontend.id
}

output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.frontend.domain_name
}

output "cloudfront_url" {
  description = "The URL of the CloudFront distribution"
  value       = "https://${aws_cloudfront_distribution.frontend.domain_name}"
}