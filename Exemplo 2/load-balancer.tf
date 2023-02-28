### CRIAR o LOAD BALANCER ####
resource "aws_lb" "lb1" {
  name               = "load-balancer"
  internal           = false
  load_balancer_type = "application"
  subnets            = [for subnet in aws_subnet.subnet_public : subnet.id]
  security_groups    = ["${aws_security_group.instance_sg.id}"]

  tags = {
    name = "lb-desafio-02"
  }
}

### CRIAR O GRUPO DE DESTINO DO LOAD BALANCER ####
resource "aws_lb_target_group" "lb_target_group" {
  name = "lb-target-group"
  #target_type = "alb"         ### somente para LB do tipo NETWORK LOAD BALANCER
  target_type = "instance"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  stickiness {
    type = "lb_cookie"
  }

   health_check {
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }
}

### CRIAR LISTENER HTTP ####
resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = aws_lb.lb1.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

### CRIAR LISTENER HTTPS ####
resource "aws_lb_listener" "lb_listener_https" {
  load_balancer_arn = aws_lb.lb1.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = data.aws_acm_certificate.certificate.arn
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}