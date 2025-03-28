# ============================================================================
# BACKEND MODULE - ECS SERVICE
# ============================================================================
# Este archivo define el servicio ECS que ejecutará la aplicación backend,
# incluyendo la configuración de red y balanceo de carga.
# ============================================================================

resource "aws_ecs_service" "backend" {
  name            = "${var.project}-${var.environment}-backend-service"
  cluster         = aws_ecs_cluster.backend.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = var.desired_count  # Número de instancias de la tarea
  launch_type     = "FARGATE"          # Uso de Fargate (serverless)

  # Configuración de red para las tareas
  network_configuration {
    subnets          = [var.private_subnet_id]  # Ejecutar en subnet privada
    security_groups  = [var.backend_security_group_id]
    assign_public_ip = false                     # No se necesita IP pública
  }

  # Configuración del balanceador de carga
  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn  # Grupo de destino para las tareas
    container_name   = "${var.project}-${var.environment}-backend"
    container_port   = 8080                              # Puerto del contenedor
  }

  # Dependencia del listener HTTP para evitar errores de despliegue
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