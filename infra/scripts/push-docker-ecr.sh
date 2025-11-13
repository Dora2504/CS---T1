#!/usr/bin/env bash
set -euo pipefail

CREDENTIALS_FILE="../../aws_credentials.env"
if [ -f "$CREDENTIALS_FILE" ]; then
    echo "Carregando credenciais AWS do arquivo $CREDENTIALS_FILE..."
    set -o allexport
    # shellcheck disable=SC1090
    source "$CREDENTIALS_FILE"
    set +o allexport
else
    echo "Erro: arquivo $CREDENTIALS_FILE não encontrado."
    exit 1
fi

for cmd in aws docker; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Erro: '$cmd' não encontrado no PATH. Instale e tente novamente."
        exit 1
    fi
done

if ! aws sts get-caller-identity --output json >/dev/null 2>&1; then
    echo "❌ Credenciais inválidas ou expiradas. Verifique $CREDENTIALS_FILE."
    exit 1
fi
echo "✅ Credenciais AWS válidas."

AWS_REGION="${AWS_REGION:-us-east-1}"
AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
REPO_NAME="${REPO_NAME:-cs-lambda}"
IMAGE_NAME="${IMAGE_NAME:-cs-lambda}"
TAG="${TAG:-latest}"

ROOT_DIR="$(cd "$(dirname "$0")/../.." && pwd)"

if ! docker image inspect "${IMAGE_NAME}:${TAG}" >/dev/null 2>&1; then
    echo "Imagem local ${IMAGE_NAME}:${TAG} não encontrada. Tentando construir..."
    docker build -t "${IMAGE_NAME}:${TAG}" -f "${ROOT_DIR}/Dockerfile" "${ROOT_DIR}"
fi

if ! aws ecr describe-repositories --repository-names "${REPO_NAME}" --region "${AWS_REGION}" >/dev/null 2>&1; then
    echo "Repositório ECR ${REPO_NAME} não encontrado. Criando..."
    aws ecr create-repository --repository-name "${REPO_NAME}" --region "${AWS_REGION}" >/dev/null
fi

echo "Fazendo login no ECR..."
aws ecr get-login-password --region "${AWS_REGION}" | \
    docker login --username AWS --password-stdin "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

FULL_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}:${TAG}"

echo "Taggeando a imagem local..."
docker tag "${IMAGE_NAME}:${TAG}" "${FULL_URI}"

echo "Fazendo push da imagem para o ECR..."
docker push "${FULL_URI}"

echo "Imagem enviada com sucesso: ${FULL_URI}"

echo "Atualizando Lambda com a nova imagem..."
aws lambda update-function-code \
    --function-name cs_lambda \
    --image-uri "${FULL_URI}" \
    --region "${AWS_REGION}"


echo "Lambda atualizada com sucesso!"

// ...existing code...
#!/usr/bin/env bash
set -euo pipefail

# Resolve script directory and set credentials path relative to script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
CREDENTIALS_FILE="$(cd "$SCRIPT_DIR/../.." && pwd)/aws_credentials.env"

if [ -f "$CREDENTIALS_FILE" ]; then
    echo "Carregando credenciais AWS do arquivo $CREDENTIALS_FILE..."
    set -o allexport
    # shellcheck disable=SC1090
    source "$CREDENTIALS_FILE"
    set +o allexport
else
    echo "Erro: arquivo $CREDENTIALS_FILE não encontrado."
    exit 1
fi
// ...existing code...