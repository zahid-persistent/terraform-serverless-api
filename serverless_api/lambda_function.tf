locals {
  function_name = "getRaceResults"
}

variable "lambda_file" {
  type = string
  default = "lambda.py"
}

variable "lambda_zip_file" {
  type = string
  default = "lambda.zip"
}

data "archive_file" "notification_lambda" {
  type = "zip"

  source_file = "${path.module}/${var.lambda_file}"
  output_path = "${path.module}/${var.lambda_zip_file}"
}

resource "aws_lambda_function" "this" {
  filename = "${path.module}/${var.lambda_zip_file}"
  function_name = local.function_name
  role = aws_iam_role.this.arn
  handler = "lambda.send_message"

  source_code_hash = filebase64sha256("${path.module}/${var.lambda_zip_file}")

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
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = 14
}