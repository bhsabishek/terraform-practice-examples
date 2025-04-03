terraform {
  backend "s3" {
    bucket         = "cstm-terraform-state-bucket-01"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
