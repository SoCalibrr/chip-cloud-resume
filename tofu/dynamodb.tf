resource "aws_dynamodb_table" "resume-table" {
  name           = "chip-cloud-resume-counter"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "record_id"

  attribute {
    name = "record_id"
    type = "S"
  }
}

# Can't be imported
# resource "aws_dynamodb_table_item" "resume-table-item" {
#   table_name = aws_dynamodb_table.resume-table.name
#   hash_key   = aws_dynamodb_table.resume-table.hash_key

#   item = <<ITEM
# {
#   "record_id": {
#     "S": "0"
#   },
#   "visit_count": {
#     "N": "103"
#   }
# }
# ITEM
# }
