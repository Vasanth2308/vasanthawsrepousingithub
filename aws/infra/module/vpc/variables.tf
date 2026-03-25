variable "vpc_cidr" {}
variable "vpc_name" {}
variable "public_subnet_cidr" {}
variable "az" {}
variable "private_subnet_cidrs" {
  type = list(string)
}
variable "private_subnet_azs" {
  type = list(string)
}