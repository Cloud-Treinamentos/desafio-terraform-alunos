
resource "aws_vpc" "Main" {
  cidr_block           = var.CIDR-VPC
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.VPCName
  }
}

resource "aws_subnet" "Public" {
  count             = length(data.aws_availability_zones.available.names) #var.PublicSubnetsCount
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.Main.id
  cidr_block        = "${cidrsubnet(var.CIDR-VPC, 8, count.index)}"
  map_public_ip_on_launch = true
  tags = {
    Name = "${join("-", [var.VPCName, "Subnet-Public", count.index])}"
  }
}

resource "aws_subnet" "Private" {
  count             = length(data.aws_availability_zones.available.names)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.Main.id
  cidr_block        = "${cidrsubnet(var.CIDR-VPC, 8, ((count.index)+30))}"
  tags = {
    Name = "${join("-", [var.VPCName, "Subnet-Private", count.index])}"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.Main.id

  tags = {
    Name = "${var.VPCName}-IGW" #"InternetGateway"
  }
}

resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.Main.id

  tags = {
    Name = "RT"
  }
}

resource "aws_route_table_association" "rta" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = aws_subnet.Public[count.index].id
  route_table_id = aws_route_table.RT.id
}


resource "aws_route" "Public" {
  route_table_id         = aws_route_table.RT.id
  destination_cidr_block = var.Internet
  gateway_id             = aws_internet_gateway.IGW.id

}
