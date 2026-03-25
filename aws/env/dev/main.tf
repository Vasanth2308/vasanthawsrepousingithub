module "vpc" {
  source = "../../infra/module/vpc"

  vpc_cidr           = var.vpc_cidr
  vpc_name           = var.vpc_name
  public_subnet_cidr = var.public_subnet_cidr
  az                 = var.az
  private_subnet_cidrs = var.private_subnet_cidrs
  private_subnet_azs   = var.private_subnet_azs
}

################################################################################
# EC2 Module
################################################################################

# module "ec2" {
#   source = "../../infra/module/ec2"

#   project_name     = var.project_name
#   environment      = var.environment
#   instance_type    = var.instance_type
#   root_volume_size = var.root_volume_size
#   tags             = local.common_tags

#   # Passed directly from VPC module — no hardcoding
#   vpc_id           = module.vpc.vpc_id
#   subnet_id        = module.vpc.subnet_id
# }

################################################################################
# Local — common tags applied to every module
################################################################################
module "rds" {
  source = "../../infra/module/rds"

  db_identifier = "dev-rds-db"
  db_name       = "devdb"
  db_username   = "admin"

  subnet_ids = module.vpc.private_subnet_ids
  vpc_security_group_ids = [module.ec2.sg_id]
}

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner
  }
}