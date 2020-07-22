resource "aws_api_gateway_resource" "getRaceResults" {
  parent_id = aws_api_gateway_rest_api.serverless_api.root_resource_id
  path_part = aws_lambda_function.getRaceResults.function_name
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
}

resource "aws_api_gateway_method" "getRaceResults" {
  authorization = "NONE"
  http_method = "GET"
  resource_id = aws_api_gateway_resource.getRaceResults.id
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
}

resource "aws_api_gateway_integration" "getRaceResults" {
  http_method = aws_api_gateway_method.getRaceResults.http_method
  resource_id = aws_api_gateway_resource.getRaceResults.id
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.getRaceResults.invoke_arn
}

resource "aws_api_gateway_deployment" "getRaceResults" {
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
  stage_name = "prod"

  triggers = {
    redeployment = sha1(join(",", list(
      jsonencode(aws_api_gateway_integration.getRaceResults),
    )))
  }
}

resource "aws_lambda_permission" "getRaceResults" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.getRaceResults.function_name
  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.serverless_api.execution_arn}/*/*/*"
}