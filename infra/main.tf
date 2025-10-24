terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # O provider Docker é usado para construir e enviar a imagem para o ECR
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# 1. Repositório ECR
resource "aws_ecr_repository" "lambda_repo" {
  name                 = var.project_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_caller_identity" "current" {}

locals {
  ecr_repository_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${aws_ecr_repository.lambda_repo.name}"
  image_full_uri     = "${local.ecr_repository_url}:${var.image_tag}"
}

# 2. Construir e Enviar a imagem Docker para o ECR
resource "docker_image" "lambda_image" {
  name         = local.image_full_uri
  # O contexto é o diretório onde o seu Dockerfile e o código fonte estão (deve ser o diretório atual)
  context      = "." 
  # O build_target deve ser o nome do seu estágio final no Dockerfile
  build_target = "default" 

  # Este bloco ajuda o Terraform a reconstruir e reenviar a imagem quando o código-fonte muda
  # Ele gera um hash do conteúdo do diretório 'src' e usa isso como gatilho
  triggers = {
    # Altere 'src' pelo diretório que contem seu código-fonte, ou '.' para tudo
    dir_hash = filebase64sha256(join("", [for f in fileset(path.module, "src/**") : filebase64sha256(f)]))
  }
  
  # Este bloco garante que a imagem será enviada para o ECR
  # 'with_push = true' é o que realmente faz o 'push'
  provisioner "local-exec" {
    command = "docker push ${local.image_full_uri}"
  }
}

# Define um VPC para o seu projeto
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

# Define as sub-redes em diferentes zonas de disponibilidade
resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Altere para uma AZ da sua região
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b" # Altere para uma AZ da sua região
}

# Cria o DB Subnet Group para o RDS
resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "rds-subnet-group-academy"
  subnet_ids  = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
  description = "DB subnet group for the RDS instance"
}


