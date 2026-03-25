aws_region   = "us-east-1"
vpc_cidr           = "10.0.0.0/16"
vpc_name           = "dev-vpc"
public_subnet_cidr = "10.0.1.0/24"
az                 = "us-east-1a"
environment  = "dev"
project_name = "vasanth-aws"
owner            = "vasanth"
private_subnet_cidrs = [
  "10.0.11.0/24",
  "10.0.12.0/24"
]

private_subnet_azs = [
  "us-east-1b"
]
# instance_type    = "t2.medium"
# root_volume_size = 20

