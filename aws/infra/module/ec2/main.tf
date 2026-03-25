################################################################################
# TLS Key Pair — Terraform generates it automatically
################################################################################

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save private key as a .pem file locally so you can SSH in
resource "local_file" "private_key_pem" {
  content         = tls_private_key.this.private_key_pem
  filename        = "${path.module}/generated/${var.project_name}-${var.environment}.pem"
  file_permission = "0600"   # owner read-only — required for SSH
}

resource "aws_key_pair" "this" {
  key_name   = "${var.project_name}-${var.environment}-key"
  public_key = tls_private_key.this.public_key_openssh

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-key"
  })
}

################################################################################
# Security Group
################################################################################

resource "aws_security_group" "this" {
  name        = "${var.project_name}-${var.environment}-ec2-sg"
  description = "EC2 SG - allows SSH/HTTP/HTTPS from deployer IP only"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP - Nginx"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS - Nginx"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-ec2-sg"
  })
}

################################################################################
# EC2 Instance
################################################################################

resource "aws_instance" "this" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.this.id]
  key_name                    = aws_key_pair.this.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install nginx1 -y
    sudo systemctl start nginx
    sudo systemctl enable nginx
    sudo bash -c 'cat > /usr/share/nginx/html/index.html <<HTML
    <!DOCTYPE html>
    <html>
      <head><title>${var.project_name} - ${var.environment}</title></head>
      <body style="font-family:Arial;text-align:center;padding:50px;background:#f4f4f4;">
        <h1>Nginx is running!</h1>
        <p>Project: ${var.project_name}</p>
        <p>Environment: ${var.environment}</p>
        <p>Deployed by Terraform</p>
      </body>
    </html>
    HTML'
  EOF

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = true
  }

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-ec2"
  })
}

################################################################################
# Elastic IP
################################################################################

resource "aws_eip" "this" {
  instance = aws_instance.this.id
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-eip"
  })
}
