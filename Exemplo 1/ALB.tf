resource "aws_lb" "ALBDesafio2G4" {
  name = "ALBDesafio2G4"
  #ELB com uma porta voltada para Internet (Intenal = false)
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALB-SG.id]
  subnets            = [for subnet in aws_subnet.Public : subnet.id]

  #Se este parâmetro estiver = true, o Terrafom não conseguirá destruir o stack
  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

# create target group
resource "aws_lb_target_group" "alb_target_group" {
  name        = "Desafio-2-G4-TargetGroup"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.Main.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/az.html"
    timeout             = 10
    matcher             = 200
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  lifecycle {
    create_before_destroy = true
  }
}

# create a listener on port 80 with redirect action
resource "aws_lb_listener" "alb_http_listener" {
  load_balancer_arn = aws_lb.ALBDesafio2G4.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn

  }
}

# create a listener on port 443 with forward action
resource "aws_lb_listener" "alb_https_listener" {
  load_balancer_arn  = aws_lb.ALBDesafio2G4.arn
  port               = "443"
  protocol           = "HTTPS"
  ssl_policy         = "ELBSecurityPolicy-2016-08"
  certificate_arn    = aws_acm_certificate.acm_certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn 
  }
}
