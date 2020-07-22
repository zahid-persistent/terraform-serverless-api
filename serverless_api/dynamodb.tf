resource "aws_dynamodb_table" "this" {
  name           = "RaceResults"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "Driver"
  range_key      = "Date"

  attribute {
    name = "Date"
    type = "S"
  }

  attribute {
    name = "Driver"
    type = "S"
  }
}