provider "aws" {
  region = "ap-south-1"  # Change to your preferred AWS region
}

# 🔹 Create a Security Group
resource "aws_security_group" "my_sg" {
  name        = "terraform-sg"
  description = "Allow SSH and HTTP"

  # Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open to all (change for security)
  }

  # Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 🔹 Launch an EC2 Instance
resource "aws_instance" "my_ec2" {
  ami             = "ami-0e35ddab05955cf57"  # Ubuntu AMI (Change as needed)
  instance_type   = "t2.micro"
  key_name        = "mac_abi"
  security_groups = [aws_security_group.my_sg.name]

  tags = {
    Name = "Terraform-EC2"
  }
}
