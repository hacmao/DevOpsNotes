resource "aws_security_group" "main" {
  name = "khr-api-${var.tags.environment}"

  //  ingress {
  //    from_port   = 443
  //    protocol    = "tcp"
  //    to_port     = 443
  //    cidr_blocks = ["0.0.0.0/0"]
  //  }

  ingress {
    from_port   = 8000
    protocol    = "tcp"
    to_port     = 8000
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = var.vpc.vpc_id[0]

  tags = var.tags
}
