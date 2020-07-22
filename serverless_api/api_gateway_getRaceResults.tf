resource "aws_api_gateway_deployment" "getRaceResults" {
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
  stage_name = "prod"

  triggers = {
    redeployment = sha1(join(",", list(
      jsonencode(aws_api_gateway_integration.getRaceResults),
    )))
  }

 // lifecycle {
  //  create_before_destroy = true
 // }

  //depends_on = [aws_api_gateway_method.getRaceResults]
}

resource "aws_api_gateway_resource" "getRaceResults" {
  path_part   = aws_lambda_function.getRaceResults.function_name
  parent_id   = aws_api_gateway_rest_api.serverless_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.serverless_api.id
}

resource "aws_api_gateway_method" "getRaceResults" {
  rest_api_id   = aws_api_gateway_rest_api.serverless_api.id
  resource_id   = aws_api_gateway_resource.getRaceResults.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "getRaceResults" {
  rest_api_id             = aws_api_gateway_rest_api.serverless_api.id
  resource_id             = aws_api_gateway_resource.getRaceResults.id
  http_method             = aws_api_gateway_method.getRaceResults.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.getRaceResults.invoke_arn
}

resource "aws_lambda_permission" "getRaceResults" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.getRaceResults.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.serverless_api.execution_arn}/*/*/*"
}