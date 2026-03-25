output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.this.id
}

output "elastic_ip" {
  description = "Static Elastic IP — use this to access Nginx"
  value       = aws_eip.this.public_ip
}

output "private_ip" {
  description = "Private IP inside VPC"
  value       = aws_instance.this.private_ip
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.this.id
}

output "nginx_url" {
  description = "Nginx URL — open this in browser"
  value       = "http://${aws_eip.this.public_ip}"
}

output "ssh_command" {
  description = "SSH command — run this to connect"
  value       = "ssh -i infra/module/ec2/generated/${var.project_name}-${var.environment}.pem ec2-user@${aws_eip.this.public_ip}"
}

output "pem_file_path" {
  description = "Path to the generated private key file"
  value       = "infra/module/ec2/generated/${var.project_name}-${var.environment}.pem"
}

output "sg_id" {
  value = aws_security_group.ec2_sg.id
}

# # output "deployer_ip_in_sg" {
# #   description = "Your public IP auto-added to the security group"
# #   value       = local.my_public_ip
# # }
