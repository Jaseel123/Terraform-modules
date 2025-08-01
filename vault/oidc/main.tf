resource "vault_policy" "this" {
  name   = "${var.role_bindings.role_name}-policy"
  policy = templatefile("${path.module}/policy.tpl", { vault_paths = var.role_bindings.vault_paths, vault_additional_permissions = var.role_bindings.vault_additional_permissions })
}

resource "vault_jwt_auth_backend_role" "this" {
  backend    = "oidc"
  role_name  = var.role_bindings.role_name
  user_claim = "email"
  allowed_redirect_uris = [
    "${var.vault_endpoint}/ui/vault/auth/oidc/oidc/callback"
  ]
  bound_claims = {
    "groups" = var.role_bindings.azure_group_id
  }
  groups_claim   = "groups"
  token_policies = [vault_policy.this.name]
  oidc_scopes    = ["https://graph.microsoft.com/.default"]
}

resource "vault_identity_group" "this" {
  name     = var.role_bindings.role_name
  type     = "external"
  policies = [vault_policy.this.name]

  metadata = {
    version = "1"
  }
}

resource "vault_identity_group_alias" "group_alias" {
  name           = var.role_bindings.azure_group_id
  mount_accessor = var.vault_oidc_accessor_id
  canonical_id   = vault_identity_group.this.id
}
