#Security Group - Wordpress
resource "aws_security_group" "sg_wp" {
  name        = "sg_wordpress"
  vpc_id      = aws_vpc.vpc.id
  description = "Libera portas 22 e 80"

  #regras de entrada
  ingress {
    description = "Libera portas 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.sg_cidrs
  }

  ingress {
    description = "Libera portas 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.sg_cidrs
  }

  #regras de saida
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Security Group - MySQL
resource "aws_security_group" "sg_bd" {
  name        = "sg_mysql"
  vpc_id      = aws_vpc.vpc.id
  description = "Libera porta 3306"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.sg_wp.id}"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_lb" {
  name        = "sg_loadbalancer"
  vpc_id      = aws_vpc.vpc.id
  description = "Libera porta 80 no LB"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}