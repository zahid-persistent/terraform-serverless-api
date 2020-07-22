data "archive_file" "createRaceResults" {
  type = "zip"

  source_file = "${path.module}/lambda_createRaceResult.py"
  output_path = "${path.module}/lambda_createRaceResult.zip"
}

resource "aws_lambda_function" "getRaceResults" {
  filename = "${path.module}/lambda_createRaceResult.zip"
  function_name = "createRaceResult"
  role = aws_iam_role.this.arn
  handler = "lambda_createRaceResult.main"

  source_code_hash = filebase64sha256("${path.module}/lambda_createRaceResult.zip")

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

resource "aws_cloudwatch_log_group" "getRaceResults" {
  name              = "/aws/lambda/createRaceResult"
  retention_in_days = 14
}