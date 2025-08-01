# Vault Terraform Module
This repo includes 3 modules.

kubernetes-auth-backend: for enabling kubernetes service account based authentication for accessing vault
VRSA(Vault Role for Service Accounts): for granting access to vault secrets for the service accounts
oidc: for enabling user access based on azure ad group mapping

## Requirements

| Name | Version |
|------|---------|
| terraform| >= 1.7 |
| aws| >= 5.37 |
| vault | >= 3.25 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.37 |
| vault | >= 3.25 |

## kubernetes-auth-backend

### Resources

| Name | Type |
|------|------|
| [vault_kv_secret_v2](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/kv_secret_v2) | data source |
| [vault_auth_backend](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/auth_backend) | resource |
| [vault_kubernetes_auth_backend_config](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kubernetes_auth_backend_config) | resource |
| [vault_policy](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_api_endpoint | Kubernetes API endpoint | `string` | `null` | yes |

### outputs

| Name | Description |
|------|-------------|
| vault_auth_backend_path | mount path for kubernetes auth type |

## VRSA

### Resources

| Name | Type |
|------|------|
| [vault_kubernetes_auth_backend_config](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kubernetes_auth_backend_config) | resource |
| [vault_policy](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |


### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| role_bindings | Mapping of azure AD group to the vault group and policy | `any` | `null` | yes |
| vault_auth_backend_path | mount path for kubernetes auth type | `string` | `null` | yes |

## oidc

### Resources

| Name | Type |
|------|------|
| [vault_policy](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [vault_jwt_auth_backend_role](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role) | resource |
| [vault_identity_group](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group) | resource |
| [vault_identity_group_alias](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_alias) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vault_oidc_accessor_id | accessor ID for OIDC auth type | `string` | `null` | yes |
| vault_endpoint | URL of the vault | `string` | `null` | yes |
| role_bindings | Mapping of azure AD group to the vault group and policy | `any` | `null` | yes |