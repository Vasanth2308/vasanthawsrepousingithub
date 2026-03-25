variable "vpc_cidr" {}
variable "vpc_name" {}
variable "public_subnet_cidr" {}
variable "az" {}
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name used for tagging"
  type        = string
  default     = "vasanth-aws"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
}

variable "owner" {
  description = "Team or person who owns this environment"
  type        = string
}