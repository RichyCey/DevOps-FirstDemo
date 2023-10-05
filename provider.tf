terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~>2.20.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

data "aws_secretsmanager_secret_version" "creds" {
  # Fill in the name you gave to your secret
  secret_id = "terraform_keys"
}

locals {
  terraform_keys = jsondecode(
    data.aws_secretmanager_secret_version.creds.secret_string
  )
}


# configuring docker and aws as providers
provider "docker" {}

provider "aws" {
  region     = var.aws_region
  access_key = local.terraform_keys.terraform_access_key
  secret_key = local.terraform_keys.terraform_secret_access_key
}