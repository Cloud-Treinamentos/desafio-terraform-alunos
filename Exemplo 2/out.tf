### EXPORTAR OS IDs DAS SUBNETS PUBLICAS ####
output "public_subnet" {
  value = aws_subnet.subnet_public[*].id
}

### EXPORTAR OS IDs DAS SUBNETS PRIVADAS ####
output "private_subnet" {
  value = aws_subnet.subnet_private[*].id
}

### EXPORTAR O NOME DNS DO EFS ####
output "efs_dns_name" {
  #value = aws_efs_file_system.efs.id
  value = aws_efs_file_system.efs.dns_name
}

### EXPORTAR O ARN DO CERTIFICADO ####
# output "aws_acm_certificate" {
#  value = aws_acm_certificate.certificate.arn
# }

### EXPORTAR O ACCESS POINT DO EFS PARA FAZER A MONTAGEM NA INSTANCIA ####
output "efs_access_point" {
  value = aws_efs_access_point.efs_access_point.id
}

### EXPORTAR O PONTO DE MONTAGEM DO EFS ####
output "aws_efs_mount_target" {
  value = aws_efs_mount_target.efs_mount[*].id
}

### EXPORTAR O ID DO GRUPO DE AUTO SCALING ####
output "auto_scaling_group" {
  value = aws_autoscaling_group.scalegroup.id
}

### EXPORTAR AS ZONAS DE DISPONIBILIDADES ####
output "availabilityzones" {
   value = data.aws_availability_zones.available.all_availability_zones
 }

# output "availabilityzones" {
#   value = ["us-east-1a", "us-east-1b"]
# }

### EXPORTAR O NOME DE DNS DO LOAD BALANCER ####
output "alb-dns" {
  value = aws_lb.lb1.dns_name
}

### EXPORTAR OS IPs PUBLICOS DAS INSTANCIAS ####
output "ip_instance" {
  value = aws_launch_configuration.wordpress.associate_public_ip_address
}