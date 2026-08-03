resource "aws_s3_bucket" "name" {
  bucket = "proj-winters-backend"
  tags = {
    Name = "proj-winters-backend"
  }
}