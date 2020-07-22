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

#resource "aws_api_gateway_integration" "getRaceResults" {
# TODO
#}

#resource "aws_api_gateway_deployment" "getRaceResults" {
# TODO
#}

#resource "aws_lambda_permission" "getRaceResults" {
# TODO
#}