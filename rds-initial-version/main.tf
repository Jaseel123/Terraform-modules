resource "random_password" "rds_password" {
  length           = var.rds_password_length
  special          = false
  override_special = "_!#%^&*()-+=[]{}|:<>?,."
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  count       = var.config_groups ? 1 : 0
  name        = var.subnet_group_name
  subnet_ids  = var.subnets
  description = "Custom subnet group created by Terraform"
  tags        = merge(var.tags, var.db_subnet_group_tags)
}

resource "aws_db_parameter_group" "rds_parameter_group" {
  count  = var.config_groups ? 1 : 0
  name   = var.db_parameter_group_name
  family = var.parametr_group_family
  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }
  description = "Custom parameter group created by Terraform"
  tags        = merge(var.tags, var.db_parameter_group_tags)
}

resource "aws_db_option_group" "rds_option_group" {
  count                    = var.config_groups ? 1 : 0
  name                     = var.option_group_name
  engine_name              = var.option_group_engine
  major_engine_version     = var.option_group_engine_version
  dynamic "option" {
    for_each = var.options
    content {
      option_name                    = option.value.option_name
      port                           = lookup(option.value, "port", null)
      version                        = lookup(option.value, "version", null)
      db_security_group_memberships  = lookup(option.value, "db_security_group_memberships", null)
      vpc_security_group_memberships = lookup(option.value, "vpc_security_group_memberships", null)

      dynamic "option_settings" {
        for_each = lookup(option.value, "option_settings", [])
        content {
          name  = lookup(option_settings.value, "name", null)
          value = lookup(option_settings.value, "value", null)
        }
      }
    }
  }
  option_group_description = "Custom option group created by Terraform"
  tags                     = merge(var.tags, var.db_option_group_tags)
}

resource "aws_db_instance" "rds_instance" {
  apply_immediately           = var.apply_immediately
  allocated_storage           = var.storage_size
  max_allocated_storage       = 2 * var.storage_size
  storage_type                = var.storage_type
  engine                      = var.engine
  engine_version              = var.engine_version
  instance_class              = var.instance_type
  identifier                  = var.identifier
  db_name                     = var.rds_name
  username                    = var.username
  multi_az                    = var.multi_az
  port                        = var.port
  publicly_accessible         = false
  password                    = random_password.rds_password.result
  vpc_security_group_ids      = var.security_group_ids
  tags                        = var.tags
  maintenance_window          = var.maintenance_window
  backup_retention_period     = var.backup_retention_window
  backup_window               = var.backup_window
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  deletion_protection         = var.deletion_protection
  skip_final_snapshot         = var.skip_final_snapshot
  final_snapshot_identifier   = var.final_snapshot_identifier


  // Group configs
  db_subnet_group_name = var.config_groups ? aws_db_subnet_group.rds_subnet_group[0].name : var.subnet_group_name
  parameter_group_name = var.config_groups ? aws_db_parameter_group.rds_parameter_group[0].name : var.db_parameter_group_name
  option_group_name    = var.config_groups ? aws_db_option_group.rds_option_group[0].name : var.option_group_name

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null
  performance_insights_kms_key_id       = var.performance_insights_enabled ? var.performance_insights_kms_key_id : null

  // Encryption at rest
  kms_key_id            = var.encryption_at_rest ? var.kms_key_id : null
  storage_encrypted     = var.encryption_at_rest
  copy_tags_to_snapshot = var.copy_tags_to_snapshot

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
}

resource "aws_db_instance" "rds_instance_read_replica" {
  count                       = var.create_read_replica ? 1 : 0

  apply_immediately           = var.apply_immediately
  storage_type                = var.storage_type
  engine                      = null
  engine_version              = var.engine_version
  instance_class              = var.replica_instance_type
  identifier                  = "${var.identifier}-replica"
  replicate_source_db         = aws_db_instance.rds_instance.identifier
  username                    = null
  password                    = random_password.rds_password.result
  multi_az                    = false
  port                        = var.port
  publicly_accessible         = false
  vpc_security_group_ids      = var.replica_security_group_ids
  tags                        = var.tags
  maintenance_window          = var.maintenance_window
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  deletion_protection         = var.deletion_protection
  skip_final_snapshot         = true
  parameter_group_name = var.config_groups ? aws_db_parameter_group.rds_parameter_group[0].name : var.db_parameter_group_name
  option_group_name    = var.config_groups ? aws_db_option_group.rds_option_group[0].name : var.option_group_name
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null
  performance_insights_kms_key_id       = var.performance_insights_enabled ? var.performance_insights_kms_key_id : null
  kms_key_id            = var.encryption_at_rest ? var.kms_key_id : null
  storage_encrypted     = var.encryption_at_rest
  copy_tags_to_snapshot = var.copy_tags_to_snapshot
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
}

resource "vault_generic_secret" "database_password" {
  path = var.vault_path

  data_json = <<EOT
{
  "password": "${random_password.rds_password.result}"
}
EOT
}

################################################################################
# CloudWatch Log Group for log exports
################################################################################

resource "aws_cloudwatch_log_group" "this" {
  for_each = toset([for log in var.enabled_cloudwatch_logs_exports : log])

  name              = "/aws/rds/instance/${var.identifier}/${each.value}"
  retention_in_days = var.cloudwatch_log_retention
  kms_key_id        = var.cloudwatch_log_group_export_kms_key_id
  tags              = var.tags
}