resource "aws_db_subnet_group" "main" {
  name       = "axiom-${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "axiom-${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

# BUG IC-02: multi_az is disabled. If the primary instance fails or the AZ
# goes down, the database is unavailable until AWS manually recovers it
# (typically 20-40 minutes). Production databases must have multi_az = true.
#
# BUG IC-02: backup_retention_period = 0 disables automated backups entirely.
# Any data written after the last manual snapshot is permanently lost on
# instance failure. For production, set to at least 7 days.
#
# BUG IC-07: There is no lifecycle block with prevent_destroy = true.
# A developer running `terraform destroy` or a CI pipeline misconfiguration
# will permanently delete the production database with no prompt.
# Also: skip_final_snapshot = true means no snapshot is taken on deletion.
resource "aws_db_instance" "primary" {
  identifier        = "axiom-${var.environment}-db"
  engine            = "postgres"
  engine_version    = "15.4"
  instance_class    = "db.t3.large"
  allocated_storage = 100
  storage_encrypted = true
  storage_type      = "gp3"

  db_name  = "axiom"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_sg_id]

  multi_az                = false
  backup_retention_period = 0
  skip_final_snapshot     = true

  tags = {
    Name        = "axiom-${var.environment}-db"
    Environment = var.environment
  }
}
