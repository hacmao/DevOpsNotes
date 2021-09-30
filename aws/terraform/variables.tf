variable "tf_provider" {
  type = map(any)
  default = {
    "dev" : {
      "s3_key" : "terraform.dev.state",
      "bucket" : "khr-terraform-state"
    }
  }
}

variable "region" {}
variable "profile" {}

# ASG
variable "ami_id" {}
variable "asg_instance_type" {}
variable "asg_health_check_type" {}
variable "asg_desired_size" {}
variable "asg_min_size" {}
variable "asg_max_size" {}
variable "asg_min_cpu" {}
variable "asg_max_cpu" {}

# RDS
variable "db_instance_type" {}
variable "db_instance_name" {}

variable "tags" {
  default = {
    "environment" : "dev",
    "system" : "khr"
  }
}
