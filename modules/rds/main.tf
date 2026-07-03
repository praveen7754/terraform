/*
RDS Module - Main Configuration
Manages Relational Database Service instances and configurations.
*/

# Create DB subnet group
resource "aws_db_subnet_group" "main" {
  name       = "${var.db_subnet_group_name}-${var.environment}"
  subnet_ids = var.db_subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.db_subnet_group_name}-${var.environment}"
    }
  )
}

# Create RDS instances
resource "aws_db_instance" "main" {
  for_each = var.db_instances

  identifier            = "${each.key}-${var.environment}"
  engine                = each.value.engine
  engine_version        = each.value.engine_version
  instance_class        = each.value.instance_class
  allocated_storage     = each.value.allocated_storage
  storage_type          = each.value.storage_type
  storage_encrypted     = each.value.storage_encrypted
  multi_az              = each.value.multi_az
  db_name               = each.value.db_name
  username              = each.value.username
  password              = each.value.password
  db_subnet_group_name  = aws_db_subnet_group.main.name
  vpc_security_group_ids = var.security_group_ids
  publicly_accessible   = false

  backup_retention_period = each.value.backup_retention_days
  backup_window           = each.value.backup_window
  maintenance_window      = each.value.maintenance_window
  
  skip_final_snapshot       = each.value.skip_final_snapshot
  final_snapshot_identifier = try("${each.key}-${var.environment}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}", null)
  deletion_protection       = each.value.deletion_protection

  enabled_cloudwatch_logs_exports = [
    "error",
    "general",
    "slowquery"
  ]

  tags = merge(
    var.tags,
    {
      Name = "${each.key}-${var.environment}-database"
    }
  )

  depends_on = [aws_db_subnet_group.main]
}
