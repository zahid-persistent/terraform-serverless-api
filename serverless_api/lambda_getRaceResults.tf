data "archive_file" "notification_lambda" {
  type = "zip"

  source_file = "${path.module}/lambda_getRaceResults.py"
  output_path = "${path.module}/lambda_getRaceResults.zip"
}

resource "aws_lambda_function" "this" {
  filename = "${path.module}/lambda_getRaceResults.zip"
  function_name = "getRaceResults"
  role = aws_iam_role.this.arn
  handler = "lambda_getRaceResults.main"

  source_code_hash = filebase64sha256("${path.module}/lambda_getRaceResults.zip")

  runtime = "python3.7"

  environment {
    variables = {
      DEBUG = "false"
      SLACK_WEBHOOK = var.slack_webhook
    }
  }

  # in seconds
  timeout = 10

  tags = {
    Name = var.name
    Contact = var.contact_tag
  }

  depends_on = [
    data.archive_file.notification_lambda, aws_cloudwatch_log_group.this]
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/getRaceResults"
  retention_in_days = 14
}