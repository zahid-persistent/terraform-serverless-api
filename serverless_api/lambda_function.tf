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

resource "aws_iam_role" "this" {
  name = var.name

  assume_role_policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = var.name
    Contact = var.contact_tag
  }
}

resource "aws_lambda_function" "this" {
  filename = "${path.module}/${var.lambda_zip_file}"
  function_name = var.name
  role = aws_iam_role.this.arn
  handler = "lambda.send_message"

  source_code_hash = filebase64sha256("${path.module}/${var.lambda_zip_file}")

  runtime = "python3.7"

  environment {
    variables = {
      DEBUG = "false"
    }
  }

  # in seconds
  timeout = 10

  tags = {
    Name = var.name
    Contact = var.contact_tag
  }

  depends_on = [
    data.archive_file.notification_lambda]
}