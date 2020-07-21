//
//resource "aws_api_gateway_rest_api" "this" {
//  name = var.name
//}
//
//resource "aws_api_gateway_deployment" "this" {
//  rest_api_id = aws_api_gateway_rest_api.this.id
//  stage_name  = "prod"
//
//  lifecycle {
//    create_before_destroy = true
//  }
//
//  depends_on = [aws_api_gateway_method.this]
//}
//
//resource "aws_api_gateway_stage" "this" {
//  stage_name    = "prod"
//  rest_api_id   = aws_api_gateway_rest_api.this.id
//  deployment_id = aws_api_gateway_deployment.this.id
//}
//
//
//resource "aws_api_gateway_resource" "this" {
//  path_part   = "commitMessages"
//  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
//  rest_api_id = aws_api_gateway_rest_api.this.id
//}
//
//resource "aws_api_gateway_method" "this" {
//  rest_api_id   = aws_api_gateway_rest_api.this.id
//  resource_id   = aws_api_gateway_resource.this.id
//  http_method   = "GET"
//  authorization = "NONE"
//
//
//}
//
//
//resource "aws_api_gateway_integration" "this" {
//  rest_api_id             = aws_api_gateway_rest_api.this.id
//  resource_id             = aws_api_gateway_resource.this.id
//  http_method             = aws_api_gateway_method.this.http_method
//  integration_http_method = "POST"
//  type                    = "AWS_PROXY"
//  uri                     = aws_lambda_function.this.invoke_arn
//}


//resource "aws_lambda_permission" "this" {
//  statement_id  = "AllowExecutionFromAPIGateway"
//  action        = "lambda:InvokeFunction"
//  function_name = aws_lambda_function.this.function_name
//  principal     = "apigateway.amazonaws.com"
//
//  source_arn = "${data.aws_api_gateway_rest_api.this.execution_arn}/*/*/*"
//}
