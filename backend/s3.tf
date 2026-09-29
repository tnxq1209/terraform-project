resource "aws_s3_bucket" "name" {
  bucket = "project-state-winters-backend"
  tags = {
    Name = "project-state-winters-backend"
  }
}