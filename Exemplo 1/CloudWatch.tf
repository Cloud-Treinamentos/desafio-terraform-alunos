# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "testapp_log_group" {
  name              = "/ecs/testapp"
  retention_in_days = 5

  tags = {
    Name = "cw-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "myapp_log_stream" {
  name           = "test-log-stream"
  log_group_name = aws_cloudwatch_log_group.testapp_log_group.name
}

resource "aws_cloudwatch_metric_alarm" "ASGG4Alarm" {
  alarm_name                = "ASGG4Alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
}
