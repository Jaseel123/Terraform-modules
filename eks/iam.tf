resource "aws_iam_role" "eks_master_role" {
  name = "${var.cluster_name}-master-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-master-role"
  })
}

resource "aws_iam_role_policy_attachment" "associate_master_role_managed_policy" {
  for_each   = toset(var.master_role.managed_policies)
  policy_arn = "${local.managed_policy_prefix}/${each.key}"
  role       = aws_iam_role.eks_master_role.name
}

resource "aws_iam_role" "eks_worker_role" {
  name = "${var.cluster_name}-worker-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-worker-role"
  })
}

resource "aws_iam_role_policy_attachment" "associate_worker_role_managed_policy" {
  for_each   = toset(var.worker_role.managed_policies)
  policy_arn = "${local.managed_policy_prefix}/${each.key}"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_policy" "worker_role_custom_policy" {
  name   = "${var.cluster_name}-worker-role-custom-policy"
  policy = data.aws_iam_policy_document.custom_policy_document.json
}

resource "aws_iam_role_policy_attachment" "associate_worker_role_custom_policy" {
  role       = aws_iam_role.eks_worker_role.name
  policy_arn = aws_iam_policy.worker_role_custom_policy.arn
}

resource "aws_iam_policy" "ebs_csi_custom_policy" {
  name   = "${var.cluster_name}-ebs-csi-custom-policy"
  policy = data.aws_iam_policy_document.ebs_csi_custom_policy.json
}

resource "aws_iam_role" "ebs_csi_driver" {
  name               = "aws-ebs-csi-driver-role"
  assume_role_policy = data.aws_iam_policy_document.ebs_trust_policy.json
  tags               = local.common_tags
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_driver.name
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_custom_policy" {
  policy_arn = aws_iam_policy.ebs_csi_custom_policy.arn
  role       = aws_iam_role.ebs_csi_driver.name
}

resource "aws_iam_policy" "efs_csi_custom_policy" {
  name   = "${var.cluster_name}-efs-csi-custom-policy"
  policy = data.aws_iam_policy_document.efs_csi_custom_policy.json
}

resource "aws_iam_role" "efs_csi_driver" {
  name               = "aws-efs-csi-driver-role"
  assume_role_policy = data.aws_iam_policy_document.efs_trust_policy.json
  tags               = local.common_tags
}

resource "aws_iam_role_policy_attachment" "efs_csi_driver_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
  role       = aws_iam_role.efs_csi_driver.name
}

resource "aws_iam_role_policy_attachment" "efs_csi_driver_custom_policy" {
  policy_arn = aws_iam_policy.efs_csi_custom_policy.arn
  role       = aws_iam_role.efs_csi_driver.name
}
