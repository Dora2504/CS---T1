#!/bin/bash

#!/bin/bash

# ======== Carrega variáveis da AWS do arquivo .env, se existir ========
CREDENTIALS_FILE="../../aws_credentials.env"  # ajuste o caminho relativo correto
if [ -f "$CREDENTIALS_FILE" ]; then
    echo "Carregando credenciais AWS do arquivo $CREDENTIALS_FILE..."
    export $(grep -v '^#' "$CREDENTIALS_FILE" | xargs)
else
    echo "Erro: arquivo $CREDENTIALS_FILE não encontrado."
    exit 1
fi

# ======== Verifica se as credenciais são válidas ========
if aws sts get-caller-identity --output json >/dev/null 2>&1; then
    echo "✅ Credenciais AWS válidas."
else
    echo "❌ Credenciais inválidas ou expiradas. Verifique $CREDENTIALS_FILE."
    exit 1
fi




# Configurações
AWS_REGION="us-east-1"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
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

# 4. Atualizar a Lambda para usar a nova imagem
echo "Atualizando Lambda com a nova imagem..."
aws lambda update-function-code \
    --function-name cs_lambda \
    --image-uri $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME:$TAG

echo "Lambda atualizada com sucesso!"

