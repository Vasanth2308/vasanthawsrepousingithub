#######################################
# VPC
#######################################
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

#######################################
# Public Subnet (Single)
#######################################
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = true

  availability_zone = var.az   # single AZ

  tags = {
    Name = "${var.vpc_name}-public-subnet"
  }
}

#######################################
# Private Subnets (Multiple)
#######################################
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id     = aws_vpc.this.id
  cidr_block = var.private_subnet_cidrs[count.index]

  availability_zone = var.private_subnet_azs[count.index]  # ✅ FIXED

  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index}"
  }
}

#######################################
# Internet Gateway
#######################################
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

#######################################
# Public Route Table
#######################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

#######################################
# Public Route Association
#######################################
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

#######################################
# Private Route Table (NO INTERNET)
#######################################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

#######################################
# Private Route Table Association
#######################################
resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}