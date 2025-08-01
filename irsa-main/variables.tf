variable "eks_cluster_oidc_provider_url" {
  type        = string
  description = "OIDC Provider URL"
}

variable "eks_cluster_oidc_provider_arn" {
  type        = string
  description = "OIDC Provider ARN"
}

variable "service_account" {
  type        = string
  description = "Name of the service account where IAM needs to be mapped"
}

variable "namespace" {
  type        = string
  description = "Namespace of the service account where the role needs to be mapped"
}

variable "policies" {
  type        = any
  description = "Required policies for the service account"
}

variable "tags" {
  description = "Madatory Tags"
  type        = map(string)
  default     = {}
}