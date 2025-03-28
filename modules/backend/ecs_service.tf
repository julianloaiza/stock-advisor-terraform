resource "aws_ecs_service" "backend" {
  name            = "${var.project}-${var.environment}-backend-service"
  cluster         = aws_ecs_cluster.backend.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [var.private_subnet_id]
    security_groups = [var.backend_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${var.project}-${var.environment}-backend"
    container_port   = 8080
  }

  depends_on = [
    aws_lb_listener.http
  ]

  tags = merge(
    {
      Name = "${var.project}-${var.environment}-backend-service"
    },
    var.tags
  )
}
