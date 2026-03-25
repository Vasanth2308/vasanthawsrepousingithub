################################################################################
# Data — Latest Amazon Linux 2 AMI
################################################################################

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

################################################################################
# Data — Auto-detect caller's public IP for SG
################################################################################

data "http" "my_public_ip" {
  url = "https://checkip.amazonaws.com"
}

locals {
  my_public_ip = "${chomp(data.http.my_public_ip.response_body)}/32"
}
