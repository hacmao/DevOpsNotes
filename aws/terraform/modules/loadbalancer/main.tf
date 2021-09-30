resource "aws_security_group" "lb_security" {
  name   = "${var.lb_name}-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "all"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_lb" "api_lb" {
  name                             = var.lb_name
  internal                         = false
  load_balancer_type               = "application"
  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = true

  subnet_mapping {
    subnet_id = var.public_subnets[0]
  }
  subnet_mapping {
    subnet_id = var.public_subnets[1]
  }

  security_groups = [aws_security_group.lb_security.id]
  tags            = var.tags
}

resource "aws_lb_listener" "http_redirect" {
  load_balancer_arn = aws_lb.api_lb.arn
  port              = 80
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

resource "aws_lb_target_group" "ec2_tg" {
  name                 = var.ec2_tg
  vpc_id               = var.vpc_id
  deregistration_delay = 30
  target_type          = "ip"
  protocol             = "HTTP"
  port                 = 8080

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 300
    unhealthy_threshold = 5
    timeout             = 60
  }

  tags = var.tags
}

resource "aws_lb_listener" "https_tg" {
  load_balancer_arn = aws_lb.api_lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_tg.arn
  }
}


