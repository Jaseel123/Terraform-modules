locals {
  # https://github.com/hashicorp/terraform-provider-aws/blob/3c4cb52c5dc2c09e10e5a717f73d1d8bc4186e87/internal/service/elasticache/cluster.go#L271
  in_replication_group    = var.replication_group_id != null
  port                    = var.engine == "memcached" ? 11211 : 6379
  num_node_groups         = var.cluster_mode_enabled ? var.num_node_groups : null
  inter_subnet_group_name = try(coalesce(var.subnet_group_name, var.cluster_id, var.replication_group_id), "")
  subnet_group_name       = var.create_subnet_group ? aws_elasticache_subnet_group.this[0].name : var.subnet_group_name
}