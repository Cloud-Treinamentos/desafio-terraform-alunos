resource "aws_db_instance" "RDS" {
  allocated_storage    = 20
  db_name              = "dbG4"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "Grupo4"
  password             = "DesafioG4$#*"
  #parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.DBSubnetGroup.name
  port     = "3306"
  vpc_security_group_ids = [aws_security_group.RDS.id]
  publicly_accessible = true
  tags = {
    Name = "RDS-Desafio2-G4"
  }
}

resource "aws_db_subnet_group" "DBSubnetGroup" {
  name       = "dbsubnetgroup"
  subnet_ids = [aws_subnet.Private[0].id,aws_subnet.Private[1].id]

  tags = {
    Name = "DBSubnetGroup"
  }
}
