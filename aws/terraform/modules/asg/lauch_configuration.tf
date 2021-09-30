resource "aws_key_pair" "main" {
  key_name = "khr-dev"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCXjVN4F4KVNOOu+MqqJPm/RmYpk9wX5KR4MFHxO08kdwOl3oeVc7BzvXJBkB446c0zguu3c5qmF/6+lN8BhqIOUvjVoxnl+whrEwZdoQNxayWe5xFIgEcbv7gYm3mLORyr+3CbD3pG9iKgKOZEyR70ntmQXZHvRc10d4jsCwvPUqJy6znyib+ouawtCXuJMpMOA47rsWKdOOc4S+TtT1Z8BQSh/PANj8nFmd0gcc2/l7ZIGHHFTMt0ayh2Rin62Lkon3OFwAYQfikBzI/A9TSlJMBoDMVGR+c4vn9RlISxg0+NZ0OC/xNcc+qGjiflUa2oduYuUSeEMFD55V6MjeY7"
}

resource "aws_launch_configuration" "main" {
  name_prefix   = "${var.tags["system"]}-conf-${var.tags["environment"]}-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name = aws_key_pair.main.key_name
  security_groups = [aws_security_group.main.id]

  lifecycle {
    create_before_destroy = true
  }
}
