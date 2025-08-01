resource "aws_efs_file_system" "efs" {
  creation_token                  = var.name
  performance_mode                = var.efs_performance_mode
  encrypted                       = true
  kms_key_id                      = var.kms_key_id
  provisioned_throughput_in_mibps = var.efs_throughput_mode == "provisioned" ? var.provisioned_throughput_in_mibps : null
  throughput_mode                 = var.efs_throughput_mode

  dynamic "lifecycle_policy" {
    for_each = [for k, v in var.lifecycle_policy : { (k) = v }]

    content {
      transition_to_ia                    = try(lifecycle_policy.value.transition_to_ia, null)
      transition_to_archive               = try(lifecycle_policy.value.transition_to_archive, null)
      transition_to_primary_storage_class = try(lifecycle_policy.value.transition_to_primary_storage_class, null)
    }
  }

  tags = merge(
    var.tags,
    { Name = "${var.name}" },
  )
}

resource "aws_efs_mount_target" "efs_mount_target" {
  for_each = length(var.mount_target.subnet_ids) > 0 ? toset(var.mount_target.subnet_ids) : []

  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = each.value
  security_groups = var.mount_target.security_groups
}
