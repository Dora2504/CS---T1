#!/bin/bash

# Configurações
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID="891377042208"   # substitua pelo seu AWS Account ID
REPO_NAME="cs-lambda"
IMAGE_NAME="cs-lambda"
TAG="latest"

# 1. Fazer login no ECR
echo "Fazendo login no ECR..."
aws ecr get-login-password --region $AWS_REGION | \
    docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
if [ $? -ne 0 ]; then
    echo "Erro ao logar no ECR"
    exit 1
fi

# 2. Taggear a imagem local para o ECR
echo "Taggeando a imagem local..."
docker tag $IMAGE_NAME:$TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME:$TAG

# 3. Push da imagem para o ECR
echo "Fazendo push da imagem para o ECR..."
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME:$TAG

echo "Imagem enviada com sucesso!"