resource "aws_lambda_function" "app" {
  function_name = "cs_lambda"
  filename      = "${path.module}/../build/libs/demo-0.0.1-SNAPSHOT-plain.jar"
  handler       = "com.meuapp.StreamLambdaHandler::handleRequest"
  runtime       = "java17"
  role          =
  memory_size   = 1024
  timeout       = 30
}
