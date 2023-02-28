resource "aws_security_group" "LiberaTudo" {
  name        = "SGDesafio"
  description = "Allow all internet traffic"
  vpc_id      = aws_vpc.Main.id


  ingress {
    description = "allows all inbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.Internet]
  }

  egress {
    description = "allows all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.Internet]
  }

  tags = {
    Name = "allows_all"
  }
}
resource "aws_security_group" "SGInstancias" {
  name        = "SGInstancias"
  description = "SG das Instancias"
  vpc_id      = aws_vpc.Main.id


    ingress {
    description = "allows HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = [var.Internet]
  }
  ingress {
    description = "allows HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = [var.Internet]
  }
  ingress {
    description = "allows MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = [var.Internet]
  }

  ingress {
    description = "allows SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = [var.Internet]
  }

  egress {
    description = "allows all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.Internet]
  }

  tags = {
    Name = "allows_all"
  }
}
 

resource "aws_security_group" "RDS" {
  name        = "SG-Desafio-RDS"
  description = "SG para a RDS"
  vpc_id      = aws_vpc.Main.id


  ingress {
    description = "allows all inbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.Internet]
  }

  egress {
    description = "allows all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.Internet]
  }

  tags = {
    Name = "SG-Desafio-RDS"
  }
}

resource "aws_security_group" "ALB-SG" {
  name        = "ALB-SG"
  description = "Allow all internet traffic"
  vpc_id      = aws_vpc.Main.id


  ingress {
    description = "allows HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = [var.Internet]
  }
  ingress {
    description = "allows HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = [var.Internet]
  }
  ingress {
    description = "allows DNS"
    from_port   = 53
    to_port     = 53
    protocol    = "TCP"
    cidr_blocks = [var.Internet]
  }
  ingress {
    description = "allows DNS"
    from_port   = 53
    to_port     = 53
    protocol    = "UDP"
    cidr_blocks = [var.Internet]
  }
  ingress {
    description = "allows NFS"
    from_port   = 2049
    to_port     = 2049
    protocol    = "TCP"
    cidr_blocks = [var.Internet]
  }
  egress {
    description = "allows all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.Internet]
  }

  tags = {
    Name = "ALB-SG"
  }
}
