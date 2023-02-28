resource "aws_launch_configuration" "webcluster" {
  image_id                    = "ami-0d5bf08bc8017c83b" //AMI só para não dar erro, depois trocar por a do snapshot e alterar o min_size
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.sg_wp.id]
  key_name                    = lookup(var.key, var.aws_region)
  associate_public_ip_address = true

  # # EBS root
  # root_block_device {
  #   volume_size = 8
  #   volume_type = "gp2"
  # }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_security_group.sg_wp]
}

resource "aws_autoscaling_group" "scalegroup" {
  name                      = "wp_autoscaling"
  launch_configuration      = aws_launch_configuration.webcluster.name
  vpc_zone_identifier       = [aws_subnet.public1.id, aws_subnet.public2.id, aws_subnet.public3.id]
  min_size                  = 0 // <----------------------------------------Alterar aqui
  max_size                  = 4
  desired_capacity          = 0 // <----------------------------------------Alterar aqui
  force_delete              = true
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = [aws_alb_target_group.tg-load_balance.arn]

  lifecycle {
    create_before_destroy = true
  }

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  tag {
    key                 = "Name"
    value               = "wordpress-as"
    propagate_at_launch = true
  }
  depends_on = [aws_launch_configuration.webcluster]
}


resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.scalegroup.id
  lb_target_group_arn    = aws_alb_target_group.tg-load_balance.arn

  depends_on = [
    aws_autoscaling_group.scalegroup,
    aws_alb_target_group.tg-load_balance
  ]
}

resource "aws_autoscaling_policy" "autopolicy" {
  name                   = "Politica-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.scalegroup.name
}

resource "aws_cloudwatch_metric_alarm" "cpualarm" {
  alarm_name          = "terraform-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "90"

  alarm_description = "This metric monitor EC2 instance cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.autopolicy.arn}"]
}

resource "aws_autoscaling_policy" "autopolicy-down" {
  name                   = "Politica-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.scalegroup.name
}

resource "aws_cloudwatch_metric_alarm" "cpualarm-down" {
  alarm_name          = "terraform-alarm-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "40"

  alarm_description = "This metric monitor EC2 instance cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.autopolicy-down.arn}"]
}