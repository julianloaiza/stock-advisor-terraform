# ============================================================================
# NETWORKING MODULE - MAIN CONFIGURATION
# ============================================================================
# Este módulo crea la infraestructura de red fundamental para la aplicación,
# incluyendo VPC, subnets públicas y privadas, gateways y tablas de ruteo.
# ============================================================================

# ============================ VPC PRINCIPAL =============================
# VPC principal que contendrá todos los recursos de red
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true           # Habilita resolución DNS dentro de la VPC
  enable_dns_hostnames = true           # Habilita nombres DNS para instancias

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-vpc"
    }
  )
}

# Internet Gateway para permitir comunicación entre la VPC e Internet
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-igw"
    }
  )
}

# ====================== SUBNETS PÚBLICAS Y PRIVADAS =======================
# Subnet pública principal - Para recursos que requieren acceso directo a/desde Internet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true         # Asigna IPs públicas automáticamente a instancias

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-public-subnet"
      Tier = "public"
    }
  )
}

# Subnet pública secundaria - Requerida para ALB (necesita mínimo 2 AZs)
resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr2
  availability_zone       = var.availability_zone2
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-public-subnet-2"
      Tier = "public"
    }
  )
}

# Subnet privada - Para recursos que no requieren acceso directo desde Internet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-private-subnet"
      Tier = "private"
    }
  )
}

# ========================= TABLAS DE RUTEO ==========================
# Tabla de ruteo para subnets públicas - Permite tráfico hacia Internet a través de IGW
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-public-rtb"
    }
  )
}

# Ruta que dirige el tráfico a Internet a través del Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"       # Todo el tráfico externo
  gateway_id             = aws_internet_gateway.main.id
}

# Asociación de la tabla de ruteo pública con la subnet pública principal
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Asociación de la tabla de ruteo pública con la subnet pública secundaria
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

# ======================= NAT GATEWAY CONFIGURATION ======================
# IP Elástica para el NAT Gateway
resource "aws_eip" "nat" {
  vpc = true
  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-nat-eip"
    }
  )
}

# NAT Gateway - Permite que instancias en subnets privadas accedan a Internet
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id        # Ubicado en la subnet pública principal

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-nat-gw"
    }
  )

  # El NAT Gateway depende del Internet Gateway
  depends_on = [aws_internet_gateway.main]
}

# ====================== RUTEO PARA SUBNET PRIVADA ======================
# Tabla de ruteo para subnets privadas - Dirige tráfico a Internet a través del NAT Gateway
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-private-rtb"
    }
  )
}

# Ruta que dirige tráfico de Internet a través del NAT Gateway
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"        # Todo el tráfico externo
  nat_gateway_id         = aws_nat_gateway.main.id
}

# Asociación de la tabla de ruteo privada con la subnet privada
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}