variable "project_name" {
  description = "Project name used for naming resources"
  type        = string
}

variable "environment" {
  description = "Environment name — dev / staging / prod"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID from vpc module output"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID from vpc module output"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}
