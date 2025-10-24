# 5. AWS Lambda Function (usando Imagem de Contêiner)
resource "aws_lambda_function" "lambda_function" {
  function_name = var.project_name
  # Define o tipo de pacote como "Image"
  package_type  = "Image" 
  
  # A URI da imagem no ECR
  image_uri     = docker_image.lambda_image.name 
  
  # A Role de execução criada acima
  role          = aws_iam_role.lambda_exec_role.arn 

  # Memória e Timeout (opcional, mas recomendado)
  memory_size   = 512
  timeout       = 30

  # O container_image_config é OBRIGATÓRIO para imagens personalizadas.
  # Você pode definir ENTRYPOINT/CMD aqui. 
  # Se não definido, usa o que está no Dockerfile.
  # Note que o handler NÃO é usado para o tipo Image.
  # container_image_config {
  #   command = ["java", "-jar", "app.jar"] # Opcional, se precisar sobrescrever o ENTRYPOINT
  #   working_directory = "/app" # Opcional, se precisar sobrescrever o WORKDIR
  # }

  # Garante que a imagem Docker seja construída e enviada antes que o Lambda seja criado/atualizado
  depends_on = [
    docker_image.lambda_image,
  ]
}