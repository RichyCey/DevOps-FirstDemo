locals {
  terraform_keys = jsondecode(
    data.aws_secretmanager_secret_version.creds.secret_string
  )
}

aws_access_key = local.terraform_keys.terraform_access_key
aws_secret_key = local.terraform_keys.terraform_secret_access_key
