output "ALB" {
  value = aws_lb.ALBDesafio2G4.dns_name
}

output "AMI" {
  value = aws_ami_copy.amiBaseWP.id
}

output "ASG" {
  value = aws_autoscaling_group.ASG4.id
}

output "ASG2" {
  value = aws_lb_target_group.alb_target_group.arn
}

output "EFS-ID" {
  value = aws_efs_file_system.EFSG4.id
}

output "RDS-EndPoint" {
  value = aws_db_instance.RDS.endpoint
}

data "aws_instances" "instanciasIPs" {
  instance_state_names = ["running"]
}

output "IPs-Instancia" {
  value = "${data.aws_instances.instanciasIPs.private_ips}"
}