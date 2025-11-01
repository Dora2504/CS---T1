resource "aws_lambda_function" "app" {
  function_name = "cs_lambda"
  filename      = "./../build/libs/demo-0.0.1-SNAPSHOT-plain.jar"
  handler       = "com.meuapp.StreamLambdaHandler::handleRequest"
  runtime       = "java17"
  role          = "arn:aws:iam::891377042208:role/LabRole"  # role pré-existente no LabRole (ARN)
  memory_size   = 1024
  timeout       = 30
}
