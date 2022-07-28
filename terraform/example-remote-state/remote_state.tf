terraform {
 backend "s3" {
    bucket = "mybucket"
    encrypt = true
    key    = "path/to/my/key"
    dynamodb_table = "Table_name"
    region = "eu-west-1"
  }
}