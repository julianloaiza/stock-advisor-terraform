# ============================================================================
# NETWORKING MODULE - OUTPUTS
# ============================================================================
# Este archivo define las salidas del módulo de networking, proporcionando
# a otros módulos los identificadores e información de los recursos creados.
# ============================================================================

# ======================= VPC OUTPUTS =======================
output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "Bloque CIDR de la VPC"
  value       = aws_vpc.main.cidr_block
}

# ======================= SUBNET OUTPUTS =======================
output "public_subnet_id" {
  description = "ID de la subnet pública principal"
  value       = aws_subnet.public.id
}

output "public_subnet_id_2" {
  description = "ID de la subnet pública secundaria (para ALB)"
  value       = aws_subnet.public2.id
}

output "private_subnet_id" {
  description = "ID de la subnet privada (para backend)"
  value       = aws_subnet.private.id
}

# ======================= GATEWAY OUTPUTS =======================
output "internet_gateway_id" {
  description = "ID del Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "ID del NAT Gateway"
  value       = aws_nat_gateway.main.id
}

# ======================= ROUTING OUTPUTS =======================
output "public_route_table_id" {
  description = "ID de la tabla de ruteo pública"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID de la tabla de ruteo privada"
  value       = aws_route_table.private.id
}

# ======================= AVAILABILITY ZONE OUTPUTS =======================
output "availability_zone" {
  description = "Zona de disponibilidad principal utilizada para las subnets"
  value       = var.availability_zone
}

output "availability_zone2" {
  description = "Zona de disponibilidad secundaria utilizada para las subnets"
  value       = var.availability_zone2
}