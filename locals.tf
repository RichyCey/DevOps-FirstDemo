data "aws_secretsmanager_secret_version" "creds" {
  # Fill in the name you gave to your secret
  secret_id = "terraform_keys"
}

locals {
  terraform_keys = jsondecode(
    data.aws_secretmanager_secret_version.creds.secret_string
  )
}
