resource "aws_kms_key" "eks_kms_key" {
  depends_on          = [aws_iam_role.eks_master_role, aws_iam_role.eks_worker_role]
  description         = "EKS Custom KMS key for encryption and decryption"
  key_usage           = "ENCRYPT_DECRYPT"
  enable_key_rotation = "true"
  tags                = local.common_tags
}

resource "aws_kms_key_policy" "eks_kms_key_policy" {
  key_id = aws_kms_key.eks_kms_key.id
  policy = data.aws_iam_policy_document.eks_kms_key_policy.json
}

resource "aws_kms_alias" "eks_kms_key_alias" {
  name          = "alias/${var.cluster_name}-kms-key"
  target_key_id = aws_kms_key.eks_kms_key.key_id
}