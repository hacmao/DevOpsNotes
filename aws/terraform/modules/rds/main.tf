resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "db-${var.tags.system}-${var.tags.environment}"
  subnet_ids = [var.db_subnet[0], var.db_subnet[1]]
  tags       = var.tags
}

resource "aws_db_instance" "rds_mysql" {
  instance_class         = var.db_instance_type
  identifier             = "db-${var.tags.system}-${var.tags.environment}"
  engine                 = "mysql"
  engine_version         = "8.0.20"
  name                   = var.db_instance_name
  username               = var.db_username
  password               = var.db_password
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  tags                   = var.tags
}
