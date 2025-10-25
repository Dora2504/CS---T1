provider "docker" {}

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
    // Aponta o contexto de build do Docker para a pasta raiz (diretório pai)
    context    = ".."
    // O Dockerfile está no contexto (..)
    dockerfile = "Dockerfile" 
  }

  triggers = {
    # 1. Ajusta o caminho para o Dockerfile (que está um nível acima)
    dockerfile_sha = filebase64sha256("../Dockerfile") 
    
    # 2. Ajusta o caminho para o build.gradle (que está um nível acima)
    build_gradle_sha = filebase64sha256("../build.gradle")
    
    # 3. Ajusta o caminho para a pasta src/ (que está um nível acima)
    source_code_hash = sha1(join("", [
      for f in fileset(path.module, "../src/**") : filebase64sha256(f)
    ]))
  }
}