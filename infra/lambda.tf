resource "aws_lambda_function" "lambda_function" {
  function_name = var.project_name
  package_type  = "Image" 
  
  # uri da imagem no rep ecr
  image_uri     = docker_image.lambda_image.name 
  
  # role criada no arquivo iam
  role          = aws_iam_role.lambda_exec_role.arn 

  # Memória e Timeout (opcional, mas recomendado)
  memory_size   = 512
  timeout       = 30

  depends_on = [
    docker_image.lambda_image,
  ]
}