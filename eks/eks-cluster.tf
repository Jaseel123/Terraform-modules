resource "aws_cloudwatch_log_group" "eks_cluster_log_group" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.cluster_logs_retention
  kms_key_id        = aws_kms_key.eks_kms_key.arn
  tags              = local.common_tags
}

resource "aws_eks_cluster" "eks_cluster" {
  depends_on = [aws_cloudwatch_log_group.eks_cluster_log_group]
  name       = var.cluster_name
  role_arn   = aws_iam_role.eks_master_role.arn
  version    = var.cluster_version
  vpc_config {
    endpoint_private_access = var.endpoint_access.private
    endpoint_public_access  = var.endpoint_access.public
    security_group_ids = [
      aws_security_group.security_group["master-sg"].id,
      aws_security_group.security_group["endpoint-sg"].id
    ]
    subnet_ids = toset(var.subnet_ids)
  }
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = aws_kms_key.eks_kms_key.arn
    }
  }
  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}"
  })
}

resource "null_resource" "cluster-calico-addon" {
  depends_on = [aws_eks_cluster.eks_cluster]
  provisioner "local-exec" {
    command = "ansible-playbook templates/kubernetes-ansible.yaml -e region=${var.region} -e eks_cluster_arn=${aws_eks_cluster.eks_cluster.arn} -e eks_cluster_ca=${aws_eks_cluster.eks_cluster.certificate_authority[0].data} -e eks_cluster_endpoint=${aws_eks_cluster.eks_cluster.endpoint} -e eks_cluster_name=${aws_eks_cluster.eks_cluster.name}"
  }
}

resource "null_resource" "gp3-sc-provisioner" {
  depends_on = [null_resource.cluster-calico-addon]
  provisioner "local-exec" {
    command = "ansible-playbook templates/kubernetes-gp3-ansible.yaml -e region=${var.region} -e eks_cluster_arn=${aws_eks_cluster.eks_cluster.arn} -e eks_cluster_ca=${aws_eks_cluster.eks_cluster.certificate_authority[0].data} -e eks_cluster_endpoint=${aws_eks_cluster.eks_cluster.endpoint} -e kms_key_arn=${aws_kms_key.eks_kms_key.arn} -e eks_cluster_name=${aws_eks_cluster.eks_cluster.name}"
  }
}

resource "null_resource" "efs-sc-provisioner" {
  count      = var.enable_efs ? 1 : 0
  depends_on = [null_resource.cluster-calico-addon]
  provisioner "local-exec" {
    command = "ansible-playbook templates/kubernetes-efs-ansible.yaml -e region=${var.region} -e eks_cluster_arn=${aws_eks_cluster.eks_cluster.arn} -e eks_cluster_ca=${aws_eks_cluster.eks_cluster.certificate_authority[0].data} -e eks_cluster_endpoint=${aws_eks_cluster.eks_cluster.endpoint} -e kms_key_arn=${aws_kms_key.eks_kms_key.arn} -e eks_cluster_name=${aws_eks_cluster.eks_cluster.name} -e efs_file_system_id=${aws_efs_file_system.efs[0].id}"
  }
}

resource "aws_iam_openid_connect_provider" "eks_cluster_oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_cluster_tls_certificate.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.eks_cluster_tls_certificate.url
}

resource "aws_eks_addon" "eks_cluster_addons" {
  count                    = length(var.addons)
  cluster_name             = var.cluster_name
  addon_name               = var.addons[count.index].name
  addon_version            = var.addons[count.index].version
  service_account_role_arn = var.addons[count.index].service_account_role_enabled ? "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.addons[count.index].name}-role" : null
  tags                     = local.common_tags
  depends_on               = [aws_eks_cluster.eks_cluster, aws_iam_role.ebs_csi_driver]
}

