# ============================================================================
# SECURITY MODULE - OUTPUTS
# ============================================================================
# Este archivo define las salidas del módulo de seguridad, proporcionando
# acceso a los IDs de grupos de seguridad y ARNs de roles IAM para uso
# en otros módulos, especialmente en los módulos de frontend y backend.
# ============================================================================

# ==================== SECURITY GROUP OUTPUTS ====================
output "alb_security_group_id" {
  description = "ID del grupo de seguridad para el Application Load Balancer"
  value       = aws_security_group.alb.id
}

output "frontend_security_group_id" {
  description = "ID del grupo de seguridad para el servicio frontend"
  value       = aws_security_group.frontend.id
}

output "backend_security_group_id" {
  description = "ID del grupo de seguridad para el servicio backend"
  value       = aws_security_group.backend.id
}

# ======================= IAM ROLE OUTPUTS =======================
output "ecs_task_execution_role_arn" {
  description = "ARN del rol IAM para ejecución de tareas ECS"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "ecs_task_execution_role_name" {
  description = "Nombre del rol IAM para ejecución de tareas ECS"
  value       = aws_iam_role.ecs_task_execution.name
}

output "backend_task_role_arn" {
  description = "ARN del rol IAM para tareas del backend"
  value       = aws_iam_role.backend_task.arn
}

output "backend_task_role_name" {
  description = "Nombre del rol IAM para tareas del backend"
  value       = aws_iam_role.backend_task.name
}

# ==================== IAM POLICY OUTPUTS ====================
output "ssm_access_policy_arn" {
  description = "ARN de la política IAM para acceso a SSM Parameter Store"
  value       = aws_iam_policy.ecs_task_execution_ssm_access.arn
}