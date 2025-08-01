resource "aws_launch_template" "eks_additional_nodegroup_launch_template" {
  for_each = var.additional_nodegroups
  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
  name     = "${var.cluster_name}-${each.key}"
  image_id = each.value.launch_template.ami
  vpc_security_group_ids = [
    aws_security_group.security_group["nodegroup-sg"].id,
    aws_security_group.security_group["endpoint-sg"].id
  ]
  instance_type = length(each.value.launch_template.spot_instance_types) > 0 ? null : each.value.launch_template.on_demand_instance_type
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      encrypted             = true
      volume_type           = each.value.launch_template.volume.type
      volume_size           = each.value.launch_template.volume.size
      kms_key_id            = aws_kms_key.eks_kms_key.arn
    }
  }
  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, {
      Name = "${var.cluster_name}-${each.key}"
    })
  }
  tag_specifications {
    resource_type = "volume"
    tags = merge(local.common_tags, {
      Name = "${var.cluster_name}-${each.key}"
    })
  }
  ebs_optimized = true
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }
  update_default_version = true
  user_data = base64encode(templatefile("${each.value.launch_template.user_data_path}", {
    cluster_name     = var.cluster_name
    cluster_endpoint = aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_data  = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  }))
  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-${each.key}"
  })
}

resource "aws_eks_node_group" "eks_additional_nodegroup" {
  for_each = var.additional_nodegroups
  depends_on = [
    aws_launch_template.eks_additional_nodegroup_launch_template
  ]
  cluster_name    = var.cluster_name
  capacity_type   = length(each.value.launch_template.spot_instance_types) > 0 ? "SPOT" : "ON_DEMAND"
  instance_types  = length(each.value.launch_template.spot_instance_types) > 0 ? toset(each.value.launch_template.spot_instance_types) : null
  node_group_name = "${var.cluster_name}-${each.key}"
  node_role_arn   = aws_iam_role.eks_worker_role.arn
  subnet_ids      = each.value.launch_template.subnet_ids

  launch_template {
    name    = "${var.cluster_name}-${each.key}"
    version = each.value.launch_template.version
  }
  scaling_config {
    desired_size = each.value.launch_template.scaling.desired
    max_size     = each.value.launch_template.scaling.max
    min_size     = each.value.launch_template.scaling.min
  }
  update_config {
    max_unavailable = each.value.launch_template.max_unavailable
  }
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
  labels = {
    "node_group" = each.key
    "shared"     = "true"
  }
  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-${each.key}"
  })
}
