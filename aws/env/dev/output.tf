output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnet_id" {
  value = module.vpc.subnet_id
}

output "ec2_instance_id" {
  value = module.ec2.instance_id
}

output "elastic_ip" {
  value = module.ec2.elastic_ip
}

output "nginx_url" {
  description = "Open in browser to verify Nginx"
  value       = module.ec2.nginx_url
}

output "ssh_command" {
  description = "Run this to SSH into EC2"
  value       = module.ec2.ssh_command
}

# output "deployer_ip_in_sg" {
#   description = "Your IP auto-added to security group"
#   value       = module.ec2.deployer_ip_in_sg
# }