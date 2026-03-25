############################################
# 1. Generate random password
############################################
resource "random_password" "db_password" {
  length  = 16
  special = true
}

############################################
# 2. Store in Secrets Manager
############################################
resource "aws_secretsmanager_secret" "db_secret" {
  name = "${var.db_identifier}-secret"
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = aws_secretsmanager_secret.db_secret.id

  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
  })
}

############################################
# 3. Subnet Group
############################################
resource "aws_db_subnet_group" "this" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = var.subnet_ids
}

############################################
# 4. RDS Instance
############################################
resource "aws_db_instance" "this" {
  identifier = var.db_identifier

  engine         = var.engine
  engine_version = var.engine_version

  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  db_name  = var.db_name
  username = var.db_username
  password = random_password.db_password.result   # 🔥 FROM SECRET

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids

  skip_final_snapshot = true
}