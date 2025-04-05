output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value = [for instance in aws_instance.my_ec2 : instance.public_ip]
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = [for instance in aws_instance.my_ec2 : instance.private_ip]
}
