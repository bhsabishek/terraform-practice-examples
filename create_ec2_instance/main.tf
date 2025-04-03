# Define the Terraform provider for AWS
provider "aws" {
  region = var.aws_region  # Change the region if needed
}

# Create an EC2 instance
resource "aws_instance" "my_ec2" {
  count 	= 1 # Create 1 instance
  ami           = var.ami_id # Ubuntu AMI ID for ap-south-1 (Check for your region)
  instance_type = var.instance_type
  key_name      = var.pem_key

  tags = {
    Name = var.instance_name
  }
}
