data "archive_file" "getRaceResults" {
  type = "zip"

  source_file = "${path.module}/lambda_getRaceResults.py"
  output_path = "${path.module}/lambda_getRaceResults.zip"
}

resource "aws_lambda_function" "getRaceResults" {
  filename = "${path.module}/lambda_getRaceResults.zip"
  function_name = "getRaceResults"
  handler = "lambda_getRaceResults.main"
  role = aws_iam_role.this.arn
  runtime = "python3.7"

  source_code_hash = filebase64sha256("${path.module}/lambda_getRaceResults.zip")

  environment {
    variables = {
      DEBUG = false
      SLACK_WEBHOOK = var.slack_webhook
    }
  }

  # in seconds
  timeout = 10
}

resource "aws_cloudwatch_log_group" "getRaceResults" {
  name              = "/aws/lambda/getRaceResults"
  retention_in_days = 14
}