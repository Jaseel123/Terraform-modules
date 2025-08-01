resource "aws_neptune_subnet_group" "this" {
  name        = "${var.cluster_name}-subnet-group"
  description = format("Neptune subnet group for Neptune cluster - %s", var.cluster_name)
  subnet_ids  = var.cluster_subnets
  tags        = var.tags
}

resource "aws_neptune_cluster_parameter_group" "this" {
  name        = "${var.cluster_name}-cluster-parameter-group"
  description = format("Neptune cluster parameter group for Neptune cluster - %s", var.cluster_name)
  family      = var.neptune_cluster_parameter_group_family

  dynamic "parameter" {
    for_each = var.neptune_cluster_parameter_group_parameters

    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = try(parameter.value.apply_method, "pending-reboot")
    }
  }

  tags = var.tags
}

resource "aws_neptune_parameter_group" "this" {
  name        = "${var.cluster_name}-instance-parameter-group"
  description = format("Neptune instance parameter group for Neptune cluster - %s", var.cluster_name)
  family      = var.neptune_instance_parameter_group_family

  dynamic "parameter" {
    for_each = var.neptune_instance_parameter_group_parameters

    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = try(parameter.value.apply_method, "pending-reboot")
    }
  }

  tags = var.tags
}

resource "aws_neptune_cluster_instance" "this" {
  count                        = var.num_of_neptune_instances
  identifier_prefix            = var.cluster_name
  cluster_identifier           = aws_neptune_cluster.this.id
  engine                       = var.cluster_engine
  engine_version               = var.cluster_engine_version
  instance_class               = var.cluster_instance_type
  publicly_accessible          = var.publicly_accessible
  neptune_subnet_group_name    = aws_neptune_subnet_group.this.name
  neptune_parameter_group_name = aws_neptune_parameter_group.this.name
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  apply_immediately            = var.apply_immediately
  preferred_maintenance_window = var.preferred_maintenance_window
  tags                         = var.tags
}

resource "aws_neptune_cluster" "this" {
  engine                                = var.cluster_engine
  engine_version                        = var.cluster_engine_version
  cluster_identifier                    = var.cluster_name
  availability_zones                    = var.cluster_azs
  port                                  = coalesce(var.cluster_port, 8182)
  neptune_subnet_group_name             = aws_neptune_subnet_group.this.name
  vpc_security_group_ids                = var.cluster_sgs
  iam_roles                             = var.cluster_iam_roles
  iam_database_authentication_enabled   = var.iam_database_authentication_enabled
  neptune_cluster_parameter_group_name  = aws_neptune_cluster_parameter_group.this.name
  neptune_instance_parameter_group_name = aws_neptune_parameter_group.this.name
  backup_retention_period               = var.backup_retention_period
  copy_tags_to_snapshot                 = true
  preferred_backup_window               = var.preferred_backup_window
  snapshot_identifier                   = var.snapshot_identifier
  skip_final_snapshot                   = var.skip_final_snapshot
  final_snapshot_identifier             = var.final_snapshot_identifier
  storage_encrypted                     = coalesce(var.storage_encrypted, true)
  kms_key_arn                           = var.kms_key
  enable_cloudwatch_logs_exports        = var.enable_cloudwatch_logs_exports
  allow_major_version_upgrade           = var.allow_major_version_upgrade
  preferred_maintenance_window          = var.preferred_maintenance_window
  apply_immediately                     = var.apply_immediately
  deletion_protection                   = var.deletion_protection

  dynamic "serverless_v2_scaling_configuration" {
    for_each = var.cluster_mode == "Serverless" ? [1] : [0]

    content {
      max_capacity = var.serverless_max_mem
      min_capacity = var.serverless_min_mem
    }
  }

  tags = var.tags
}