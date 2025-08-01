resource "vault_policy" "this" {
  name   = "${terraform.workspace}-${var.role_bindings.role_name}-policy"
  policy = templatefile("${path.module}/policy.tpl", { secret_paths = var.role_bindings.secret_paths, prefix = var.role_bindings.prefix })
}

resource "vault_kubernetes_auth_backend_role" "this" {
  backend                          = var.vault_auth_backend_path
  role_name                        = var.role_bindings.role_name
  bound_service_account_names      = [var.role_bindings.serviceaccount_name]
  bound_service_account_namespaces = [var.role_bindings.serviceaccount_namespace]
  token_policies                   = [vault_policy.this.name]
  token_ttl                        = "3600"
}
