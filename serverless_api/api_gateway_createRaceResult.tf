resource "aws_api_gateway_deployment" "createRaceResult" {
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
  stage_name = "prod"

  triggers = {
    redeployment = sha1(join(",", list(
      jsonencode(aws_api_gateway_integration.createRaceResult),
    )))
  }

  depends_on = [aws_api_gateway_method.createRaceResult]
}

resource "aws_api_gateway_resource" "createRaceResult" {
  path_part   = aws_lambda_function.createRaceResult.function_name
  parent_id   = aws_api_gateway_rest_api.serverless_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
}

resource "aws_api_gateway_method" "createRaceResult" {
  rest_api_id   = aws_api_gateway_rest_api.serverless_api.id
  resource_id   = aws_api_gateway_resource.createRaceResult.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "createRaceResult" {
  rest_api_id             = aws_api_gateway_rest_api.serverless_api.id
  resource_id             = aws_api_gateway_resource.createRaceResult.id
  http_method             = aws_api_gateway_method.createRaceResult.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.createRaceResult.invoke_arn
}

resource "aws_lambda_permission" "createRaceResult" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.createRaceResult.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.serverless_api.execution_arn}/*/*/*"
}