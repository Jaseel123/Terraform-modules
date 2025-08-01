resource "aws_launch_template" "eks_infra_nodegroup_launch_template" {
  depends_on = [
    aws_eks_cluster.eks_cluster
  ]
  name     = "${var.cluster_name}-infra-ng-lt"
  image_id = var.infra_nodegroup.launch_template.ami
  vpc_security_group_ids = [
    aws_security_group.security_group["nodegroup-sg"].id,
    aws_security_group.security_group["endpoint-sg"].id
  ]
  instance_type = length(var.infra_nodegroup.launch_template.spot_instance_types) > 0 ? null : var.infra_nodegroup.launch_template.on_demand_instance_type
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      delete_on_termination = true
      encrypted             = true
      volume_type           = var.infra_nodegroup.launch_template.volume.type
      volume_size           = var.infra_nodegroup.launch_template.volume.size
      kms_key_id            = aws_kms_key.eks_kms_key.arn
    }
  }
  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, {
      Name = "${var.cluster_name}-infra-nodes"
    })
  }
  tag_specifications {
    resource_type = "volume"
    tags = merge(local.common_tags, {
      Name = "${var.cluster_name}-infra-nodes"
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
  user_data = base64encode(templatefile("${var.user_data_path}", {
    cluster_name     = var.cluster_name
    cluster_endpoint = aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_data  = aws_eks_cluster.eks_cluster.certificate_authority[0].data
  }))
  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-infra-ng-lt"
  })
}

resource "aws_eks_node_group" "eks_infra_nodegroup" {
  depends_on = [
    aws_launch_template.eks_infra_nodegroup_launch_template
  ]
  cluster_name    = var.cluster_name
  capacity_type   = length(var.infra_nodegroup.launch_template.spot_instance_types) > 0 ? "SPOT" : "ON_DEMAND"
  instance_types  = length(var.infra_nodegroup.launch_template.spot_instance_types) > 0 ? toset(var.infra_nodegroup.launch_template.spot_instance_types) : null
  node_group_name = "${var.cluster_name}-infra-ng"
  node_role_arn   = aws_iam_role.eks_worker_role.arn
  subnet_ids      = var.infra_nodegroup.launch_template.subnet_ids

  launch_template {
    name    = aws_launch_template.eks_infra_nodegroup_launch_template.name
    version = aws_launch_template.eks_infra_nodegroup_launch_template.latest_version
  }
  scaling_config {
    desired_size = var.infra_nodegroup.launch_template.scaling.desired
    max_size     = var.infra_nodegroup.launch_template.scaling.max
    min_size     = var.infra_nodegroup.launch_template.scaling.min
  }
  update_config {
    max_unavailable = var.infra_nodegroup.launch_template.max_unavailable
  }
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
  labels = {
    "node_group" = "infra"
    "shared"     = "true"
  }
  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-infra-ng"
  })
}
