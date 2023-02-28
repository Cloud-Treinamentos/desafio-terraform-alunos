resource "aws_route53_zone" "hosted-zone" {
  name = "portaldofuturo.tk"
}

resource "aws_route53_record" "main-record" {
  allow_overwrite = true
  name            = "portaldofuturo.tk"
  ttl             = 172800
  type            = "NS"
  zone_id         = aws_route53_zone.hosted-zone.zone_id

  records = [
    aws_route53_zone.hosted-zone.name_servers[0],
    aws_route53_zone.hosted-zone.name_servers[1],
    aws_route53_zone.hosted-zone.name_servers[2],
    aws_route53_zone.hosted-zone.name_servers[3]
  ]
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.hosted-zone.zone_id
  name    = "www.portaldofuturo.tk"
  type    = "A"
  #ttl     = 300
  #records = [aws_instance.ins_wp.public_ip]
  #records = aws_alb_target_group.tg-load_balance.arn
  alias {
    name                   = aws_alb.load_balance.dns_name
    zone_id                = aws_alb.load_balance.zone_id
    evaluate_target_health = true
  }
  #depends_on = [aws_alb.load_balance]
}