terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
}


#Criando RDS
resource "aws_db_instance" "ins_bd" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  db_name                = "wordpress"
  username               = "adminadmin"
  password               = "adminadmin"
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = [aws_security_group.sg_bd.id]
  db_subnet_group_name   = aws_db_subnet_group.subnetGroups.name
  availability_zone      = aws_subnet.private1.availability_zone
  skip_final_snapshot    = true
  identifier             = "dbdesafio2"
}

data "template_file" "user_data" {
  template = file("./userdata.sh")
  vars = {
    rds_endpoint = "${aws_db_instance.ins_bd.endpoint}"
  }
}

#Criando EC2
resource "aws_instance" "ins_wp" {
  ami                    = lookup(var.amis, var.aws_region)
  subnet_id              = aws_subnet.public1.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg_wp.id]
  user_data              = data.template_file.user_data.rendered
  key_name               = lookup(var.key, var.aws_region)
  depends_on             = [aws_db_instance.ins_bd]
  tags = {
    Name = "Wordpress"
  }
  lifecycle {
    create_before_destroy = true
  }
}

terraform {
  backend "s3" {
    bucket = "desafio2-grupo2-terraform"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}
