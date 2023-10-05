locals {
  terraform_keys = jsondecode(
    data.aws_secretmanager_secret_version.creds.secret_string
  )
}
