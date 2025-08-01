resource "aws_msk_configuration" "this" {
  count = var.enable_custom_config ? 1 : 0

  name              = var.cluster_name
  description       = var.config_description
  kafka_versions    = [var.kafka_version]
  server_properties = join("\n", [for k, v in var.config_properties : format("%s = %s", k, v)])

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_msk_cluster" "this" {
  broker_node_group_info {
    az_distribution = var.broker_node_az_distribution
    client_subnets  = var.broker_node_subnets

    dynamic "connectivity_info" {
      for_each = length(var.broker_node_connectivity_info) > 0 ? [var.broker_node_connectivity_info] : []

      content {
        dynamic "public_access" {
          for_each = try([connectivity_info.value.public_access], [])

          content {
            type = try(public_access.value.type, null)
          }
        }

        dynamic "vpc_connectivity" {
          for_each = try([connectivity_info.value.vpc_connectivity], [])

          content {
            dynamic "client_authentication" {
              for_each = try([vpc_connectivity.value.client_authentication], [])

              content {
                dynamic "sasl" {
                  for_each = try([client_authentication.value.sasl], [])

                  content {
                    iam   = try(sasl.value.iam, null)
                    scram = try(sasl.value.scram, null)
                  }
                }

                tls = try(client_authentication.value.tls, null)
              }
            }
          }
        }
      }
    }

    instance_type   = var.broker_node_instance_type
    security_groups = var.broker_node_security_groups

    dynamic "storage_info" {
      for_each = length(var.broker_node_storage_info) > 0 ? [var.broker_node_storage_info] : []

      content {
        dynamic "ebs_storage_info" {
          for_each = try([storage_info.value.ebs_storage_info], [])

          content {
            dynamic "provisioned_throughput" {
              for_each = try([ebs_storage_info.value.provisioned_throughput], [])

              content {
                enabled           = try(provisioned_throughput.value.enabled, null)
                volume_throughput = try(provisioned_throughput.value.volume_throughput, null)
              }
            }

            volume_size = try(ebs_storage_info.value.volume_size, 64)
          }
        }
      }
    }
  }

  dynamic "client_authentication" {
    for_each = length(var.client_authentication) > 0 ? [var.client_authentication] : []

    content {
      dynamic "sasl" {
        for_each = try([client_authentication.value.sasl], [])

        content {
          iam   = try(sasl.value.iam, null)
          scram = try(sasl.value.scram, null)
        }
      }

      dynamic "tls" {
        for_each = try([client_authentication.value.tls], [])

        content {
          certificate_authority_arns = try(tls.value.certificate_authority_arns, null)
        }
      }

      unauthenticated = try(client_authentication.value.unauthenticated, null)
    }
  }

  cluster_name = var.cluster_name

  configuration_info {
    arn      = var.enable_custom_config ? aws_msk_configuration.this[0].arn : null
    revision = var.enable_custom_config ? aws_msk_configuration.this[0].latest_revision : null
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = var.kms_key_arn

    encryption_in_transit {
      client_broker = var.client_broker_comm_encryption
      in_cluster    = var.internal_broker_comm_encryption
    }
  }

  enhanced_monitoring = var.enhanced_monitoring
  kafka_version       = var.kafka_version

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = var.cloudwatch_logs_enabled
        log_group = var.cloudwatch_log_group
      }

      firehose {
        enabled         = var.firehose_logs_enabled
        delivery_stream = var.firehose_delivery_stream
      }

      s3 {
        enabled = var.s3_logs_enabled
        bucket  = var.s3_logs_bucket
        prefix  = var.s3_logs_prefix
      }
    }
  }

  number_of_broker_nodes = var.number_of_broker_nodes

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = var.jmx_exporter_enabled
      }
      node_exporter {
        enabled_in_broker = var.node_exporter_enabled
      }
    }
  }

  storage_mode = var.storage_mode

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
  }

  # required for appautoscaling
  lifecycle {
    ignore_changes = [
      broker_node_group_info[0].storage_info[0].ebs_storage_info[0].volume_size,
    ]
  }

  tags = var.tags
}

resource "aws_msk_cluster_policy" "this" {
  count = var.enable_resource_based_policy ? 1 : 0

  cluster_arn = aws_msk_cluster.this.arn
  policy      = data.aws_iam_policy_document.this[0].json
}

data "aws_iam_policy_document" "this" {
  count = var.enable_resource_based_policy ? 1 : 0

  source_policy_documents   = var.cluster_source_policy_documents
  override_policy_documents = var.cluster_override_policy_documents

  dynamic "statement" {
    for_each = var.cluster_policy_statements

    content {
      sid           = try(statement.value.sid, null)
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      effect        = try(statement.value.effect, null)
      resources     = try(statement.value.resources, [aws_msk_cluster.this[0].arn])
      not_resources = try(statement.value.not_resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = try(statement.value.not_principals, [])

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = try(statement.value.conditions, [])

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}
