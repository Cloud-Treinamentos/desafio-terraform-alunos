### CRIAR O GRUPO DE AUTO SCALING ####
resource "aws_autoscaling_group" "scalegroup" {
  name                 = "Auto-Acaling-Group"
  launch_configuration = aws_launch_configuration.wordpress.name
  vpc_zone_identifier = aws_subnet.subnet_public.*.id
  min_size            = 1
  desired_capacity    = 1
  max_size            = 2
  enabled_metrics     = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]
  metrics_granularity = "1Minute"
  target_group_arns    = ["${aws_lb_target_group.lb_target_group.arn}"]
  health_check_type         = "EC2"
  health_check_grace_period = 300

   tag {
     key                 = "Name"
     value               = "Wordpress-App"
     propagate_at_launch = true
   }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

}

### CRIAR POLITICA DE AUTO SCALING UP ####
resource "aws_autoscaling_policy" "autopolicy-up" {
  name                   = "autoplicy-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.scalegroup.name
}

### CRIAR UM ALARME NO CLOUDWATCH ####
resource "aws_cloudwatch_metric_alarm" "Politica_monitoramento_up" {
  alarm_name          = "Alarme_monitoramento_CPU"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.scalegroup.name
  }

  alarm_description = "Monitora O processamento da CPU"
  alarm_actions     = ["${aws_autoscaling_policy.autopolicy-up.arn}"]
  ok_actions        = ["${aws_autoscaling_policy.autopolicy-down.arn}"]
}

# ### CRIAR POLITICA DE AUTO SCALING DOWN ####
resource "aws_autoscaling_policy" "autopolicy-down" {
  name                   = "autoplicy-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.scalegroup.name
}

# resource "aws_cloudwatch_metric_alarm" "Politica_monitoramento_down" {
#   alarm_name          = "terraform-alarm-CPU-down"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "40"

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.scalegroup.name
#   }

#   alarm_description = "Monitora O processamento da CPU"
#   #alarm_actions     = ["${aws_autoscaling_policy.autopolicy-down.arn}"]
#   ok_actions         = ["${aws_autoscaling_policy.autopolicy-down.arn}"]
# }