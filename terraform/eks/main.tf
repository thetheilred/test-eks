resource "aws_s3_bucket" "name" {
  bucket = "my-unique-bucket-name-359ff4f828c8d92ddb3563f386184906"
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}