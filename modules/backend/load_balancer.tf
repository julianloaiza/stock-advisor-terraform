# ============================================================================
# BACKEND MODULE - LOAD BALANCER
# ============================================================================
# Este archivo define el balanceador de carga (ALB) para distribuir el tráfico
# a las instancias del servicio backend.
# ============================================================================

# Application Load Balancer (ALB) para el servicio backend
resource "aws_lb" "backend" {
  name               = "${var.project}-${var.environment}-alb"
  internal           = false                      # Accesible públicamente
  load_balancer_type = "application"              # Tipo application (capa 7)
  security_groups    = [var.alb_security_group_id]

  # Debe estar en al menos 2 subnets en diferentes zonas de disponibilidad
  subnets = [
    var.public_subnet_id,
    var.public_subnet_id_2
  ]

  enable_deletion_protection = false  # Facilita eliminación en entornos de desarrollo

  tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
  }
}

# Grupo de destino para las instancias del servicio backend
resource "aws_lb_target_group" "backend" {
  name        = "${var.project}-${var.environment}-tg"
  port        = 8080                  # Puerto de la aplicación backend
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"                  # Necesario para Fargate (usa IPs, no instancias)

  # Configuración de health check
  health_check {
    enabled             = true
    interval            = 30                  # Intervalo entre chequeos (segundos)
    path                = "/health"           # Ruta para health check
    port                = "traffic-port"      # Mismo puerto que el tráfico
    healthy_threshold   = 3                   # Chequeos exitosos para considerar healthy
    unhealthy_threshold = 3                   # Chequeos fallidos para considerar unhealthy
    timeout             = 5                   # Tiempo de espera (segundos)
    matcher             = "200"               # Códigos HTTP considerados exitosos
  }

  tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
  }
}

# Listener HTTP para el balanceador de carga
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.backend.arn
  port              = 80
  protocol          = "HTTP"

  # Acción por defecto: enviar tráfico al grupo de destino
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }

  tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
  }
}