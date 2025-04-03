provider "aws" {
  region = "ap-south-1"
}

# 🔹 Create S3 Bucket for Terraform State
resource "aws_s3_bucket" "terraform_state" {
  bucket = "cstm-terraform-state-bucket-01"

  lifecycle {
    prevent_destroy = false
  }
}

# 🔹 Enable Versioning on S3 Bucket
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 🔹 Create DynamoDB Table for State Locking
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
