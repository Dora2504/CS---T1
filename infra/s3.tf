resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-caq10151"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}