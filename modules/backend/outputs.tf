# ============================================================================
# BACKEND MODULE - OUTPUTS
# ============================================================================
# Este archivo define las salidas del módulo backend, proporcionando
# información sobre los recursos creados para uso en otros módulos.
# ============================================================================

# ====================== ECR OUTPUTS ======================
output "ecr_repository_url" {
  description = "URL del repositorio ECR para el backend"
  value       = aws_ecr_repository.backend.repository_url
}

output "ecr_repository_name" {
  description = "Nombre del repositorio ECR para el backend"
  value       = aws_ecr_repository.backend.name
}

# ====================== ECS OUTPUTS ======================
output "ecs_cluster_id" {
  description = "ID del cluster ECS"
  value       = aws_ecs_cluster.backend.id
}

output "ecs_cluster_name" {
  description = "Nombre del cluster ECS"
  value       = aws_ecs_cluster.backend.name
}

output "ecs_task_definition_arn" {
  description = "ARN de la definición de tarea ECS"
  value       = aws_ecs_task_definition.backend.arn
}

output "ecs_service_name" {
  description = "Nombre del servicio ECS"
  value       = aws_ecs_service.backend.name
}

# ====================== LOGGING OUTPUTS ======================
output "cloudwatch_log_group_name" {
  description = "Nombre del grupo de logs en CloudWatch"
  value       = aws_cloudwatch_log_group.backend.name
}

output "cloudwatch_log_group_arn" {
  description = "ARN del grupo de logs en CloudWatch"
  value       = aws_cloudwatch_log_group.backend.arn
}

# ====================== LOAD BALANCER OUTPUTS ======================
output "alb_id" {
  description = "ID del Application Load Balancer"
  value       = aws_lb.backend.id
}

output "alb_dns_name" {
  description = "Nombre DNS del Application Load Balancer"
  value       = aws_lb.backend.dns_name
}

output "alb_zone_id" {
  description = "Zone ID del Application Load Balancer (para Route53)"
  value       = aws_lb.backend.zone_id
}

# ====================== TARGET GROUP OUTPUTS ======================
output "target_group_arn" {
  description = "ARN del grupo de destino del ALB"
  value       = aws_lb_target_group.backend.arn
}

output "target_group_name" {
  description = "Nombre del grupo de destino del ALB"
  value       = aws_lb_target_group.backend.name
}

# ====================== CONFIGURATION OUTPUTS ======================
output "backend_service_url" {
  description = "URL del servicio backend (HTTP)"
  value       = "http://${aws_lb.backend.dns_name}"
}

output "backend_endpoint" {
  description = "Endpoint para el servicio backend (para uso de configuración)"
  value       = "/api/v1"
}

output "health_check_path" {
  description = "Ruta para health check del backend"
  value       = aws_lb_target_group.backend.health_check[0].path
}