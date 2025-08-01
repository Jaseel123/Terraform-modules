resource "random_password" "this" {
  for_each = { for user in var.mq_users : user.username => user }
  length   = 24
  special  = false
}

resource "vault_generic_secret" "this" {
  for_each = local.for_each_users
  path = "${var.vault_path}/${each.value.username}"

  data_json = <<EOT
{
  "password": "${random_password.this[each.value.username].result}"
}
EOT
}

resource "aws_mq_broker" "this" {
  broker_name                = var.broker_name
  engine_type                = var.engine_type
  engine_version             = var.engine_version
  host_instance_type         = var.host_instance_type

  dynamic "user" {
    for_each = length(var.mq_users) > 0 ? { for idx, user in var.mq_users : idx => user } : {}
    content {
      console_access = var.engine_type == "ActiveMQ" ? user.value.console_access : false
      groups = var.engine_type == "ActiveMQ" ? user.value.groups : []
      password = random_password.this[user.value.username].result
      username = user.value.username
      replication_user = user.value.replication_user
    }
  }

  configuration {
    id = aws_mq_configuration.this.id
    revision = aws_mq_configuration.this.latest_revision
  }

  apply_immediately          = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  data_replication_mode = var.data_replication_mode
  data_replication_primary_broker_arn = var.data_replication_mode == "CRDR" ? var.data_replication_primary_broker_arn : ""
  deployment_mode            = var.deployment_mode

  encryption_options {
    kms_key_id = var.kms_key_id
    use_aws_owned_key = false
  }

  logs {
    audit = var.audit_log_enabled
    general = var.general_log_enabled
  }

  maintenance_window_start_time {
    day_of_week = var.maintenance_window.day_of_week
    time_of_day = var.maintenance_window.time_of_day
    time_zone = var.maintenance_window.time_zone
  }

  publicly_accessible        = var.publicly_accessible
  security_groups = var.security_groups
  subnet_ids                 = var.subnet_ids
  tags                       = var.tags
}

resource "aws_mq_configuration" "this" {
  name = "${var.broker_name}-config"
  engine_type = var.engine_type
  engine_version = var.engine_version
  data = var.configuration_data
  tags = var.tags
}
