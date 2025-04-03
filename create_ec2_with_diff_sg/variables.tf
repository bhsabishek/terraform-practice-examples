variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name for EC2 instance"
  type        = string
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
}

variable "ec2_name" {
  description = "Tag name for the EC2 instance"
  type        = string
}

