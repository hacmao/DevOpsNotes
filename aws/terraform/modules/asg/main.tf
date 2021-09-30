resource "aws_autoscaling_group" "main" {
  name                      = "asg-${var.tags["system"]}-${var.tags["environment"]}"
  launch_configuration      = aws_launch_configuration.main.name
  max_size                  = var.max_size
  desired_capacity          = var.desired_size
  min_size                  = var.min_size
  health_check_grace_period = 300
  health_check_type         = var.health_check_type
  vpc_zone_identifier       = var.vpc.public_subnets

  lifecycle {
    create_before_destroy = true
  }

  tags = [var.tags]
}

