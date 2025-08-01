################################################################################
# Cluster
################################################################################

resource "aws_elasticache_cluster" "this" {
  count = var.create_cluster ? 1 : 0

  apply_immediately            = var.apply_immediately
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  availability_zone            = var.availability_zone
  cluster_id                   = var.cluster_id
  engine_version               = local.in_replication_group ? null : var.engine_version
  final_snapshot_identifier    = var.final_snapshot_identifier
  ip_discovery                 = var.ip_discovery
  maintenance_window           = local.in_replication_group ? null : var.maintenance_window
  network_type                 = var.network_type
  node_type                    = local.in_replication_group ? null : var.node_type
  notification_topic_arn       = local.in_replication_group ? null : var.notification_topic_arn
  num_cache_nodes              = local.in_replication_group ? null : var.num_cache_nodes
  parameter_group_name         = local.in_replication_group ? null : local.parameter_group_name_result
  port                         = local.in_replication_group ? null : local.port
  preferred_availability_zones = var.preferred_availability_zones
  replication_group_id         = var.create_replication_group ? aws_elasticache_replication_group.this[0].id : var.replication_group_id
  security_group_ids           = local.in_replication_group ? null : var.security_group_ids
  snapshot_retention_limit     = local.in_replication_group ? null : var.snapshot_retention_limit
  snapshot_window              = local.in_replication_group ? null : var.snapshot_window
  subnet_group_name            = local.in_replication_group ? null : local.subnet_group_name

  tags = var.tags
}

################################################################################
# Replication Group
################################################################################


resource "aws_elasticache_replication_group" "this" {
  count = var.create_replication_group ? 1 : 0

  apply_immediately          = var.apply_immediately
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  automatic_failover_enabled = var.multi_az_enabled || var.cluster_mode_enabled ? true : var.automatic_failover_enabled
  description                = coalesce(var.description, "Replication group")
  transit_encryption_enabled = true
  engine                     = var.engine
  engine_version             = var.engine_version
  final_snapshot_identifier  = var.final_snapshot_identifier
  ip_discovery               = var.ip_discovery
  kms_key_id                 = var.at_rest_encryption_enabled ? var.kms_key_arn : null
  maintenance_window         = var.maintenance_window
  multi_az_enabled           = var.multi_az_enabled
  network_type               = var.network_type
  node_type                  = var.node_type
  notification_topic_arn     = var.notification_topic_arn
  num_cache_clusters         = var.cluster_mode_enabled ? null : var.num_cache_clusters
  num_node_groups            = local.num_node_groups
  parameter_group_name       = local.parameter_group_name_result
  port                       = var.custom_port != null ? var.custom_port : local.port
  replicas_per_node_group    = var.replicas_per_node_group
  replication_group_id       = var.replication_group_id
  security_group_names       = var.security_group_names
  security_group_ids         = var.security_group_ids
  snapshot_retention_limit   = var.snapshot_retention_limit
  snapshot_window            = var.snapshot_window
  subnet_group_name          = local.subnet_group_name
  user_group_ids             = [aws_elasticache_user_group.this.id]

  tags = var.tags
}

################################################################################
# Serverless
################################################################################

resource "aws_elasticache_serverless_cache" "this" {
  count                = var.create_serverless ? 1 : 0
  engine               = var.engine
  major_engine_version = var.engine_version
  name                 = var.name
  description          = coalesce(var.description, "Elasticache Serverless")
  kms_key_id           = var.at_rest_encryption_enabled ? var.kms_key_arn : null
  security_group_ids   = var.security_group_ids
  subnet_ids           = var.subnet_ids

  dynamic "cache_usage_limits" {
    for_each = var.cache_usage_limits != null ? [true] : []
    content {

      dynamic "data_storage" {
        for_each = try(var.cache_usage_limits.data_storage, null) != null ? [true] : []

        content {
          maximum = var.cache_usage_limits.data_storage.maximum
          unit    = var.cache_usage_limits.data_storage.unit
        }
      }

      dynamic "ecpu_per_second" {
        for_each = try(var.cache_usage_limits.ecpu_per_second, null) != null ? [true] : []

        content {
          maximum = var.cache_usage_limits.ecpu_per_second.maximum
        }
      }
    }
  }

  daily_snapshot_time      = var.snapshot_window
  snapshot_retention_limit = var.snapshot_retention_limit
  user_group_id            = aws_elasticache_user_group.this.id
  snapshot_arns_to_restore = var.snapshot_arns_to_restore
  tags                     = var.tags
}

################################################################################
# Parameter Group
################################################################################

resource "random_id" "this" {
  count = var.create_parameter_group ? 1 : 0

  byte_length = 8
}

locals {
  inter_parameter_group_name  = "${try(coalesce(var.cluster_id, var.replication_group_id), "")}-${var.parameter_group_family}-${try(random_id.this[0].hex, "")}"
  parameter_group_name        = coalesce(var.parameter_group_name, local.inter_parameter_group_name)
  parameter_group_name_result = var.create_parameter_group ? aws_elasticache_parameter_group.this[0].id : var.parameter_group_name

  parameters = var.cluster_mode_enabled ? concat([{ name = "cluster-enabled", value = "yes" }], var.parameters) : var.parameters
}

resource "aws_elasticache_parameter_group" "this" {
  count = var.create_parameter_group ? 1 : 0

  description = "ElastiCache parameter group"
  family      = var.parameter_group_family
  name        = local.parameter_group_name

  dynamic "parameter" {
    for_each = local.parameters

    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

################################################################################
# Subnet Group
################################################################################
resource "aws_elasticache_subnet_group" "this" {
  count = var.create_subnet_group ? 1 : 0

  name        = local.inter_subnet_group_name
  description = "ElastiCache subnet group"
  subnet_ids  = var.subnet_ids

  tags = var.tags
}

################################################################################
# Group
################################################################################
resource "random_password" "this" {
  length           = 16
  special          = false
  override_special = "!#$%^*()-_=+[]{}|;:'\",.<>/?"
}

resource "aws_elasticache_user_group" "this" {
  engine        = "REDIS"
  user_group_id = var.user_group_ids[0]
  tags          = var.tags
  user_ids      = [aws_elasticache_user.default.user_id]

  lifecycle {
    ignore_changes = [user_ids]
  }
}

resource "aws_elasticache_user" "default" {

  access_string = try(var.default_user.access_string, "on ~* +@read")

  authentication_mode {
    type      = try(var.default_user.authentication_type, "password")
    passwords = var.default_user.authentication_type == "password" ? [random_password.this.result] : null
  }

  engine               = try(var.default_user.engine, "REDIS")
  no_password_required = try(var.default_user.no_password_required, null)
  passwords            = try(var.default_user.passwords, null)
  user_id              = var.default_user.user_id
  user_name            = "default"

  tags = var.tags
}

resource "vault_generic_secret" "this" {
  path = var.default_user.vault_path

  data_json = <<EOT
{
  "username":   "default",
  "password": "${random_password.this.result}"
}
EOT
}
