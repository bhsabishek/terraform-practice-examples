# outputs.tf

output "public_ips" {
  description = "Public IPs of the EC2 instances"
  value       = aws_instance.my_ec2[*].public_ip
}

output "private_ips" {
  description = "Private IPs of the EC2 instances"
  value       = aws_instance.my_ec2[*].private_ip
}

