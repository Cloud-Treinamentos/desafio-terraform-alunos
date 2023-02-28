### CRIAR VPC ####
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.vpc_name}"
  }
}

### ORIGEM DAS ZONAS DE DISPONIBILIDADES USADAS ####
data "aws_availability_zones" "available" {
  state = "available"
}

### CRIAR AS SUBNETS PUBLICAS ####
resource "aws_subnet" "subnet_public" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id            = aws_vpc.vpc.id
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)
  #cidr_block        = "172.16.${count.index}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "subnet-public-${count.index}"
  }
}

### CRIAR AS SUBNETS PRIVADAS ####
resource "aws_subnet" "subnet_private" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id            = aws_vpc.vpc.id
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 10)
  #cidr_block        = "172.16.${count.index + 2}.0/24"
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "subnet-private-${count.index}"
  }
}

### CRIAR O INTERNET GATEWAY ####
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "internet-gateway-desafio-02"
  }
}

### CRIAR A TABELA DE ROTAS PUBLICAS ####
resource "aws_route_table" "route_public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "route-table-public"
  }
}

### CRIAR A ASSOSSIAÇÃO DA TABELA DE ROTAS PUBLICA COM A SUBNET PUBLICA ####
resource "aws_route_table_association" "rta_public" {
  count = length(data.aws_availability_zones.available.names)

  subnet_id      = aws_subnet.subnet_public[count.index].id
  route_table_id = aws_route_table.route_public.id
}

### CRIAR A TABELA DE ROTAS PRIVADA ####
resource "aws_route_table" "route_private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "route-table-private"
  }
}

### CRIAR A ASSOSSIAÇÃO DA TABELA DE ROTAS PRIVADA COM A SUBNET PRIVADA ####
resource "aws_route_table_association" "rta_private" {
  count = length(data.aws_availability_zones.available.names)

  subnet_id      = aws_subnet.subnet_private[count.index].id
  route_table_id = aws_route_table.route_private.id
}

