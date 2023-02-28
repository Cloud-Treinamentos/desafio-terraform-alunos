/*output "ec2_public_ip" {
  value = aws_instance.ins_wp.public_ip
}*/

output "rds_endpoint" {
  value = aws_db_instance.ins_bd.endpoint
}

output "DNS_LoadBalancer" {
  value = aws_alb.load_balance.dns_name
}

output "NameServers-Route53" {
  value = [aws_route53_zone.hosted-zone.name_servers[0],
    aws_route53_zone.hosted-zone.name_servers[1],
    aws_route53_zone.hosted-zone.name_servers[2],
    aws_route53_zone.hosted-zone.name_servers[3]
  ]
}