provider "aws" {
  region  = "us-east-1"
  profile = "academy"  # ou o nome do perfil do arquivo de credenciais
}


# Get current AWS account ID automatically
data "aws_caller_identity" "current" {}
