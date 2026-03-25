module "vpc" {
  source = "../../infra/module/vpc"

  vpc_cidr           = var.vpc_cidr
  vpc_name           = var.vpc_name
  public_subnet_cidr = var.public_subnet_cidr
  az                 = var.az
}