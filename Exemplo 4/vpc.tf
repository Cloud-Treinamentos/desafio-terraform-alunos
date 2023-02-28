data "aws_availability_zones" "azs" {
}

#Criação da VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-desafio2"
  }
}

#Criação subnets publicas
resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet1-public-desafio2"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.azs.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet2-public-desafio2"
  }
}

resource "aws_subnet" "public3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = data.aws_availability_zones.azs.names[2]
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet3-public-desafio2"
  }
}

#Criação subnets privadas
resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = data.aws_availability_zones.azs.names[0]

  tags = {
    Name = "Subnet1-private-desafio2"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = data.aws_availability_zones.azs.names[1]

  tags = {
    Name = "Subnet2-private-desafio2"
  }
}

resource "aws_subnet" "private3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = data.aws_availability_zones.azs.names[2]

  tags = {
    Name = "Subnet3-private-desafio2"
  }
}

resource "aws_db_subnet_group" "subnetGroups" {
  name       = "subnet-groups"
  subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id, aws_subnet.private3.id]

  tags = {
    Name = "Subnet Groups"
  }
}

#Criação do internet gateway para subnets publicas
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "ig-desafio2"
  }
}

#Criação tabela de roteamento privada
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "rt-private-desafio2"
  }
}

#Criação tabela de roteamento publica
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt-public-desafio2"
  }
}

#Associação da tabela de roteamento privada
resource "aws_route_table_association" "private1" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private1.id
}

resource "aws_route_table_association" "private2" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private2.id
}

resource "aws_route_table_association" "private3" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private3.id
}

#Associação da tabela de roteamento publica
resource "aws_route_table_association" "public1" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public1.id
}

resource "aws_route_table_association" "public2" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public2.id
}

resource "aws_route_table_association" "public3" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public3.id
}

