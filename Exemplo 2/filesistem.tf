### CRIAR FILE SISTEM ####
resource "aws_efs_file_system" "efs" {
  creation_token = "${var.vpc_name}efs"
  encrypted      = true
  tags = {
    Name = "EFS-${var.vpc_name}"
  }
}

### MONTAR FILE SISTEM ####
resource "aws_efs_mount_target" "efs_mount" {
  count           = length(data.aws_availability_zones.available.names)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = aws_subnet.subnet_public[count.index].id
  security_groups = [aws_security_group.efs_sg.id]
}

### CRIAR ACCESS POINT #### - VERIFICAR SE PRECISA MESMO
resource "aws_efs_access_point" "efs_access_point" {
  file_system_id = aws_efs_file_system.efs.id

  tags = {
    Name = "EFS-Acces-Point"
  }
}