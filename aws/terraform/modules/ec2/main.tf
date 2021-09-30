resource "aws_key_pair" "ec2_key" {
  public_key = var.public_key
  key_name   = "${var.tags.system}-${var.tags.environment}"
  tags       = var.tags
}

resource "aws_instance" "webapp" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2_key.key_name
  vpc_security_group_ids = [aws_security_group.webapp_sg.id]
  subnet_id              = var.vpc.public_subnets[0]
  tags                   = merge(var.tags, map("Name", "${var.tags["environment"]}-api"))
}

resource "aws_lb_target_group_attachment" "lb_ec2" {
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.webapp.private_ip
  port             = 8000
}
