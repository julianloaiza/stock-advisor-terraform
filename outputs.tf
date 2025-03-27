output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.network.vpc_id
}

output "database_endpoint" {
  description = "The endpoint of the database"
  value       = module.database.endpoint
  sensitive   = true
}

output "backend_url" {
  description = "URL of the backend API"
  value       = module.backend.api_endpoint
}

output "frontend_url" {
  description = "URL of the frontend website"
  value       = module.frontend.website_url
}
