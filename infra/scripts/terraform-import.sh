#!/bin/bash

echo "Importando recursos existentes para o Terraform..."

# ======== Carregar variáveis AWS do arquivo .env ========
if [ -f "../aws_credentials.env" ]; then
    echo "Carregando credenciais AWS do arquivo aws_credentials.env..."
    export $(grep -v '^#' ../aws_credentials.env | xargs)
else
    echo "Erro: arquivo aws_credentials.env não encontrado na raiz do projeto."
    exit 1
fi

# ======== Verificar se as credenciais são válidas ========
if ! aws sts get-caller-identity --output json >/dev/null 2>&1; then
    echo "❌ Credenciais inválidas ou expiradas. Verifique ../aws_credentials.env"
    exit 1
fi

# Pegar AWS Account ID dinamicamente
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
echo "Usando AWS Account ID: $AWS_ACCOUNT_ID"

# Import ECR
terraform import aws_ecr_repository.lambda_repo cs-lambda

# Import RDS
terraform import aws_db_instance.postgres db-CFPGZFSEYPRBAKS43YRCVLBSWY

# Import Lambda Permission (usando o account ID dinâmico)
terraform import aws_lambda_permission.api_gateway_permission \
  arn:aws:lambda:us-east-1:$AWS_ACCOUNT_ID:function:cs_lambda/AllowAPIGatewayInvoke

echo "Importação concluída."
