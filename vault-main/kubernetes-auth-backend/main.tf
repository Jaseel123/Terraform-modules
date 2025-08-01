resource "vault_auth_backend" "this" {
  path        = "kubernetes/${terraform.workspace}"
  type        = "kubernetes"
  description = "Kubernetes authentication method"
}

resource "vault_kubernetes_auth_backend_config" "this" {
  backend            = vault_auth_backend.this.path
  kubernetes_host    = var.cluster_api_endpoint
  kubernetes_ca_cert = data.vault_kv_secret_v2.this.data["certificate"]
  token_reviewer_jwt = data.vault_kv_secret_v2.this.data["token"]
}