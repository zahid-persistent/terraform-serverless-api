data "archive_file" "getRaceResults" {
  type = "zip"

  source_file = "${path.module}/lambda_getRaceResults.py"
  output_path = "${path.module}/lambda_getRaceResults.zip"
}

#resource "aws_lambda_function" "getRaceResults" {
#
  # TODO
#}

resource "aws_cloudwatch_log_group" "getRaceResults" {
  name              = "/aws/lambda/getRaceResults"
  retention_in_days = 14
}