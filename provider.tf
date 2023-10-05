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

# Define an AWS Secrets Manager Secret
resource "aws_secretsmanager_secret" "my_secret" {
  name = "terraform_keys"  # Replace with the actual name or ARN of your secret
}

# Define an AWS Secrets Manager Secret Version
data "aws_secretsmanager_secret_version" "creds" {
  secret_id = aws_secretsmanager_secret.my_secret.id
}

# Access the credentials using locals or variables
locals {
  aws_access_key = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)["access_key"]
  aws_secret_access_key = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)["secret_access_key"]
}

# Explicitly define the dependency order to prevent a cycle
resource "null_resource" "dependency" {
  depends_on = [aws_secretsmanager_secret.my_secret]
}

# configuring docker and aws as providers
provider "docker" {}

provider "aws" {
  region     = var.aws_region
  access_key = local.aws_access_key
  secret_key = local.aws_secret_access_key
}