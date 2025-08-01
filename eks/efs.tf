resource "aws_efs_file_system" "efs" {
  count = var.enable_efs ? 1 : 0

  creation_token                  = "${var.cluster_name}-efs"
  performance_mode                = var.efs_performance_mode
  encrypted                       = true
  kms_key_id                      = aws_kms_key.eks_kms_key.arn
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
    { Name = "${var.cluster_name}-efs" },
  )
}

resource "aws_efs_mount_target" "efs_mount_target" {
  count = var.enable_efs ? length(var.worker_nodegroup.launch_template.subnet_ids) : 0

  file_system_id  = aws_efs_file_system.efs[0].id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = [aws_security_group.security_group["efs-sg"].id]
}
