resource "aws_alb" "load_balance" {
  name                       = "loadbalance"
  security_groups            = ["${aws_security_group.sg_lb.id}"]
  load_balancer_type         = "application"
  internal                   = false
  enable_deletion_protection = false
  subnets                    = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.public3.id]

  depends_on = [
    aws_security_group.sg_lb
  ]
}

resource "aws_alb_target_group" "tg-load_balance" {
  name        = "tg-loadbalance"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"

  vpc_id = aws_vpc.vpc.id

  health_check {
    healthy_threshold = 2
    path              = "/"
    matcher           = "200"
  }

  stickiness {
    cookie_duration = 3600
    enabled         = true
    type            = "lb_cookie"
  }
}

resource "aws_alb_listener" "listener-load_balance" {
  default_action {
    target_group_arn = aws_alb_target_group.tg-load_balance.arn
    type             = "forward"
  }

  load_balancer_arn = aws_alb.load_balance.arn
  port              = 80
  protocol          = "HTTP"

  depends_on = [aws_alb_target_group.tg-load_balance]
}