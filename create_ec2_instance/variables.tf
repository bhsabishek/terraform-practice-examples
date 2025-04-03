# variables.tf

variable "aws_region" {
  description = "The AWS region to deploy the instance"
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "The type of EC2 instance"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  default     = "ami-0e35ddab05955cf57" # Update with the latest Ubuntu AMI ID for ap-south-1
}

variable "pem_key"{
  description = "Pem Key To Use for SSH"
  default     = "mac_abi"
}

variable "instance_name" {
  description = "The name tag for the EC2 instance"
  default     = "Terraform-EC2"
}
