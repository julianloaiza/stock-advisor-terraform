output "alb_security_group_id" {
  description = "ID of the security group for the Application Load Balancer"
  value       = aws_security_group.alb.id
}

output "frontend_security_group_id" {
  description = "ID of the security group for the frontend service"
  value       = aws_security_group.frontend.id
}

output "backend_security_group_id" {
  description = "ID of the security group for the backend service"
  value       = aws_security_group.backend.id
}

output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "backend_task_role_arn" {
  description = "ARN of the backend task role"
  value       = aws_iam_role.backend_task.arn
}