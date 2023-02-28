### CRIAR SECURITY GROUP DAS INSTANCIAS ####
resource "aws_security_group" "instance_sg" {
  name   = "security_group_for_instances"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
     description = "Libera porta 80 nas instancias"
  }
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Libera ping nas instancias"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Libera SSH nas instancias"
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Libera porta 443 nas instancias"
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Security-Group-Instancias"
  }
}

### CRIAR SECURITY GROUP DO EFS ####
resource "aws_security_group" "efs_sg" {
  name        = "Security_group_EFS"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    security_groups = [aws_security_group.instance_sg.id]
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
  }

  egress {
    security_groups = [aws_security_group.instance_sg.id]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }
  tags = {
    Name = "Security-Group-EFS"
  }
}