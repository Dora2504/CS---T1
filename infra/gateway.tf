resource "aws_apigatewayv2_api" "http_api" {
  name          = "lambda-cs-t1-api"
  protocol_type = "HTTP"
  description   = "API Gateway para a Lambda Spring Boot"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.app.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "default_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default_stage" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true

  depends_on = [
    aws_apigatewayv2_route.default_route,
  ]
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.app.arn
  principal     = "apigateway.amazonaws.com"

  # Limita a permissão apenas para esta API
  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

output "api_invoke_url" {
  description = "O URL de invocação para a API Gateway"
  value       = aws_apigatewayv2_api.http_api.api_endpoint
}