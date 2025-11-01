data "aws_ecr_authorization_token" "token" {}

provider "docker" {
  registry_auth {
    address = data.aws_ecr_authorization_token.token.proxy_endpoint
    username = data.aws_ecr_authorization_token.token.user_name
    password  = data.aws_ecr_authorization_token.token.password
  }
}

# Constrói a imagem e faz push pro ECR
resource "docker_registry_image" "lambda_image" {
  name = docker_image.lambda_image.name
}


resource "docker_image" "lambda_image" {
  name = "843483113908.dkr.ecr.us-east-1.amazonaws.com/lambda-cs-t1-springboot"
  build {
    context    = "."
  } 

  triggers = {
    dockerfile_hash = filesha1("Dockerfile")
  }
}

# Docker docs: https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs