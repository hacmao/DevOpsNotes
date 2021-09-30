terraform {
  required_version = ">=0.14.0"
  backend "s3" {
    profile              = "khr-dev"
    region               = "ap-northeast-1"
    bucket               = "khr-terraform-state"
    key                  = "terraform.state"
    workspace_key_prefix = "workspace"
  }
}
