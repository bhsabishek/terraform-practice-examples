provider "aws" {
  region = var.aws_region
}

# 🔹 Create a Security Group
resource "aws_security_group" "my_sg" {
  name        = var.sg_name
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
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.my_sg.name]
  count		  = var.instance_count

  tags = {
    Name = "${var.ec2_name}-${count.index + 1}"
  }
}

