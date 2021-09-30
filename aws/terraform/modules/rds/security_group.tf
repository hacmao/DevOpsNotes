resource "aws_security_group" "rds_sg" {
  name   = "rds-${var.tags.system}-${var.tags.environment}-sg"
  vpc_id = var.vpc.vpc_id[0]

  ingress {
    from_port   = 3306
    protocol    = "tcp"
    to_port     = 3306
    cidr_blocks = [var.vpc.vpc_cidr_block[0]]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}
