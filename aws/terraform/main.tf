data "aws_ssm_parameter" "db_username"{
  name = "/rds/db_username"
}

data "aws_ssm_parameter" "db_password" {
  name = "/rds/db_password"
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = "10.3.0.0/16"
  tags     = var.tags
}

module "asg" {
  source             = "./modules/asg"
  ami_id             = var.ami_id
  instance_type      = var.asg_instance_type
  health_check_type  = var.asg_health_check_type
  desired_size       = var.asg_desired_size
  min_size           = var.asg_min_size
  max_size           = var.asg_max_size
  min_cpu            = var.asg_min_cpu
  max_cpu            = var.asg_max_cpu
  vpc                = module.vpc
  tags               = var.tags
}

module "rds" {
  source = "./modules/rds"
  db_instance_type = var.db_instance_type
  db_instance_name = var.db_instance_name
  db_username = data.aws_ssm_parameter.db_username.value
  db_password = data.aws_ssm_parameter.db_password.value
  db_subnet = module.vpc.private_subnets
  vpc = module.vpc
  tags = var.tags
}
