provider "aws" {
  profile = var.profile
  region  = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.3.0"
    }
  }
}
