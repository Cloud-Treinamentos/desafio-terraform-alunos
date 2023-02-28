resource "aws_efs_file_system" "EFSG4" {
  creation_token = "TokenEFSG4"

  tags = {
    Name = "EFSG4"
  }
}

resource "aws_efs_mount_target" "alpha" {
  count = length(aws_subnet.Public.*.id)
  file_system_id = aws_efs_file_system.EFSG4.id
  subnet_id = "${element(aws_subnet.Public.*.id, count.index)}"
  security_groups = [aws_security_group.ALB-SG.id]
}