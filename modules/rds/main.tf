# ------------------------------------------------------------------------------
# Generate a secure random password and store in Secrets Manager
# No hardcoded passwords anywhere in the code
# ------------------------------------------------------------------------------
resource "random_password" "db" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "db" {
  name                    = "${var.name}/rds/master-credentials"
  description             = "Master credentials for RDS instance ${var.name}"
  recovery_window_in_days = 7

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db.result
    host     = aws_db_instance.this.address
    port     = aws_db_instance.this.port
    dbname   = var.db_name
  })
}

# ------------------------------------------------------------------------------
# DB Subnet Group
# ------------------------------------------------------------------------------
resource "aws_db_subnet_group" "this" {
  name        = "${var.name}-subnet-group"
  description = "Subnet group for ${var.name} RDS instance"
  subnet_ids  = var.subnet_ids

  tags = merge(var.tags, {
    Name = "${var.name}-subnet-group"
  })
}

# ------------------------------------------------------------------------------
# Security Group
# ------------------------------------------------------------------------------
resource "aws_security_group" "this" {
  name        = "${var.name}-rds-sg"
  description = "Security group for ${var.name} RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow DB port from allowed security groups"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = var.allowed_security_group_ids
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-rds-sg"
  })
}

# ------------------------------------------------------------------------------
# RDS Instance
# ------------------------------------------------------------------------------
resource "aws_db_instance" "this" {
  identifier        = var.name
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.db_username
  password = random_password.db.result

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  multi_az            = var.multi_az
  publicly_accessible = false

  backup_retention_period = var.backup_retention_period

  deletion_protection   = var.deletion_protection
  skip_final_snapshot   = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.name}-final-snapshot"

  tags = merge(var.tags, {
    Name = var.name
  })
}