resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scaling-up-by-cpu"
  autoscaling_group_name = aws_autoscaling_group.main.name
  scaling_adjustment     = "1"
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "SimpleScaling"
  cooldown               = 300
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scaling-down-by-cpu"
  autoscaling_group_name = aws_autoscaling_group.main.name
  scaling_adjustment     = "-1"
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "SimpleScaling"
  cooldown               = 300
}

resource "aws_cloudwatch_metric_alarm" "scale_up" {
  alarm_name          = "asg-scale-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  evaluation_periods  = 1
  threshold           = var.max_cpu
  statistic           = "Average"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main.name
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_name          = "asg-scale-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  evaluation_periods  = 1
  threshold           = var.min_cpu
  statistic           = "Average"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.main.name
  }

  tags = var.tags
}
