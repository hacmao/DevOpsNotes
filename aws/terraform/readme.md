# Terraform

## Multi account deployment

Use terraform workspace to seperate environment.  

```bash
terraform workspace new dev
terraform workspace list
terraform workspace select dev
```


+ Configure terraform 's backend :  

```python
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
```

Use `workspace_key_prefix` to seperate terraform state between each environment. In S3 bucket, terraform will create a folder for each environment.  

+ Configure aws providers by using variable :  

```bash
provider "aws" {
  profile = var.profile
  region  = var.region
}
```

+ Run terraform with tfvars file :  

```bash
terraform apply -var-file ./vars/terraform.dev.tfvars
```
