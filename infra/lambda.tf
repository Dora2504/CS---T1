resource "aws_lambda_function" "spring_lambda" {
  function_name = "lambda-cs-t1-springboot"
  package_type  = "Image"
  role          = aws_iam_role.lambda_exec_role.arn
  image_uri     = docker_registry_image.lambda_image.name
  timeout       = 30
  memory_size   = 1024
}
