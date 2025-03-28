# ---------------------------------------------------------------------------
# VPC
# ---------------------------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-vpc"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-igw"
    }
  )
}

# ---------------------------------------------------------------------------
# PUBLIC SUBNET PRINCIPAL
# ---------------------------------------------------------------------------
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-public-subnet"
      Tier = "public"
    }
  )
}

# ---------------------------------------------------------------------------
# NUEVA PUBLIC SUBNET (SECUNDARIA para ALB) 
# ---------------------------------------------------------------------------
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

# PRIVATE SUBNET (para backend)
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

# ---------------------------------------------------------------------------
# PUBLIC ROUTE TABLE
# ---------------------------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-public-rtb"
    }
  )
}

# Route to Internet Gateway for public subnets
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Asociación con la public subnet principal
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ASOCIACIÓN con la SUBNET PUBLICA 2
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

# ---------------------------------------------------------------------------
# NAT GATEWAY (solo en la subnet pública principal)
# ---------------------------------------------------------------------------
resource "aws_eip" "nat" {
  vpc = true
  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-nat-eip"
    }
  )
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id   # <--- la de siempre

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-nat-gw"
    }
  )

  depends_on = [aws_internet_gateway.main]
}

# ---------------------------------------------------------------------------
# PRIVATE ROUTE TABLE
# ---------------------------------------------------------------------------
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-private-rtb"
    }
  )
}

# Route to NAT Gateway for private subnet
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

# Associate private subnet with the private route table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
