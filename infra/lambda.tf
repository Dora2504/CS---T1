# Cria o repositório no ECR
resource "aws_ecr_repository" "lambda_repo" {
  name = "cs-lambda"
}

resource "aws_lambda_function" "app" {
  function_name = "cs_lambda"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.lambda_repo.repository_url}:latest"
  memory_size   = 1024
  timeout       = 30
  role          = "arn:aws:iam::891377042208:role/LabRole"
}

