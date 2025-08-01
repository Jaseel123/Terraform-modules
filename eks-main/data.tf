data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_session_context" "current" {
  arn = data.aws_caller_identity.current.arn
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_iam_roles" "roles" {
  name_regex  = "AWSReservedSSO_*"
}

data "aws_iam_policy_document" "custom_policy_document" {
  statement {
    actions = [
      "ec2:ModifyInstanceAttributes"
    ]
    resources = [
      "arn:aws:ec2:*:${data.aws_caller_identity.current.account_id}:instance/*",
    ]
  }

  statement {
    actions = [
      "ec2:CreateTags",
      "ec2:DescribeTags",
      "ec2:DeleteTags"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "eks_kms_key_policy" {
  version = "2012-10-17"

  statement {
    sid    = "Allow access for Key Administrators"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "${data.aws_iam_session_context.current.issuer_arn}"
      ]
    }
    actions = [
      "kms:*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow use of the key"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "${aws_iam_role.eks_master_role.arn}",
        "${aws_iam_role.eks_worker_role.arn}",
        "${data.aws_iam_role.autoscaling_service_linked_role.arn}",
        "${aws_iam_role.ebs_csi_driver.arn}",
        "${aws_iam_role.efs_csi_driver.arn}"
      ]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "${aws_iam_role.eks_master_role.arn}",
        "${aws_iam_role.eks_worker_role.arn}",
        "${data.aws_iam_role.autoscaling_service_linked_role.arn}",
        "${aws_iam_role.ebs_csi_driver.arn}",
        "${aws_iam_role.efs_csi_driver.arn}"
      ]
    }
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }

  statement {
    sid    = "Allow read-only access"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = "${data.aws_iam_roles.roles.arns}"
    }
    actions = [
      "kms:Describe*",
      "kms:Get*",
      "kms:List*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow permissions for EFS"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["elasticfilesystem.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow permissions for Cloudwatch log groups"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logs.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }
}

data "tls_certificate" "eks_cluster_tls_certificate" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

data "aws_iam_role" "autoscaling_service_linked_role" {
  name = "AWSServiceRoleForAutoScaling"
}

data "aws_iam_policy_document" "ebs_trust_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks_cluster_oidc_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_cluster_oidc_provider.arn]
      type        = "Federated"
    }
  }
}

data "aws_iam_policy_document" "ebs_csi_custom_policy" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["${aws_kms_key.eks_kms_key.arn}"]

    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant",
    ]

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["${aws_kms_key.eks_kms_key.arn}"]

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
  }
}

data "aws_iam_policy_document" "efs_csi_custom_policy" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["${aws_kms_key.eks_kms_key.arn}"]

    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant",
    ]

    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["${aws_kms_key.eks_kms_key.arn}"]

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]
  }
}

data "aws_iam_policy_document" "efs_trust_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringLike"
      variable = "${replace(aws_iam_openid_connect_provider.eks_cluster_oidc_provider.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:efs-csi-*"]
    }

    condition {
      test     = "StringLike"
      variable = "${replace(aws_iam_openid_connect_provider.eks_cluster_oidc_provider.url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks_cluster_oidc_provider.arn]
      type        = "Federated"
    }
  }
}
