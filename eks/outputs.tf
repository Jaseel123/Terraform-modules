output "eks_master_role_arn" {
  value = aws_iam_role.eks_master_role.arn
}

output "eks_worker_role_arn" {
  value = aws_iam_role.eks_worker_role.arn
}

output "eks_kms_key_arn" {
  value = aws_kms_key.eks_kms_key.arn
}

output "eks_cluster_api_endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}

output "eks_cluster_kubeconfig_cert_authority_data" {
  value = aws_eks_cluster.eks_cluster.certificate_authority
}