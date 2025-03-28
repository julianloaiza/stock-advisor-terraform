output "connection_string_param_name" {
  description = "The SSM parameter name for the database connection string"
  value       = aws_ssm_parameter.cockroach_connection_string.name
}

output "connection_string_param_arn" {
  description = "The SSM parameter ARN for the database connection string"
  value       = aws_ssm_parameter.cockroach_connection_string.arn
}

output "ca_cert_param_name" {
  description = "The SSM parameter name for the database CA certificate"
  value       = aws_ssm_parameter.cockroach_ca_cert.name
}

output "ca_cert_param_arn" {
  description = "The SSM parameter ARN for the database CA certificate"
  value       = aws_ssm_parameter.cockroach_ca_cert.arn
}

output "stock_api_url_param_arn" {
  description = "The SSM parameter ARN for the Stock API URL"
  value       = aws_ssm_parameter.stock_api_url.arn
}

output "stock_auth_tkn_param_arn" {
  description = "The SSM parameter ARN for the Stock Auth Token"
  value       = aws_ssm_parameter.stock_auth_tkn.arn
}