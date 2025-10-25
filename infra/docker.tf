data "aws_ecr_authorization_token" "token" {}

provider "docker" {
  registry_auth {
    address = data.aws_ecr_authorization_token.token.proxy_endpoint
    username = data.aws_ecr_authorization_token.token.user_name
    password  = data.aws_ecr_authorization_token.token.password
  }
}

locals {
  aws_region_name    = "us-east-1"

  # 2. Definições da Imagem
  ecr_repository_url = "843483113908.dkr.ecr.${local.aws_region_name}.amazonaws.com/${aws_ecr_repository.lambda_repo.name}"

  image_tag          = "latest"
  ecr_image_uri      = "${local.ecr_repository_url}:${local.image_tag}"
}    

# 2. Construir e Enviar a imagem Docker para o ECR
resource "docker_image" "lambda_image" {
  name = "${local.ecr_repository_url}:${local.image_tag}"

  build {
    context    = "${path.module}/.."
    dockerfile = "${path.module}/../Dockerfile"
  }


  triggers = {
    dockerfile_sha = filebase64sha256("../Dockerfile") 
    
    build_gradle_sha = filebase64sha256("../build.gradle")
    
    source_code_hash = sha1(join("", [
      for f in fileset(path.module, "../src/**") : filebase64sha256(f)
    ]))
  }
}


# push image to ecr repo
resource "docker_registry_image" "media-handler" {
  name = docker_image.lambda_image.name
}