
data "aws_iam_policy_document" "this" {

  statement {
    actions = [
      "*"
    ]

    effect = "Allow"

    resources = [
      "arn:aws:codecommit:*:*",
  //    data.aws_dynamodb_table.this.arn
    ]

    sid = "codecommitid"
  }
}

resource "aws_iam_role_policy" "this" {
  policy = data.aws_iam_policy_document.this.json
  role = aws_iam_role.this.id
}