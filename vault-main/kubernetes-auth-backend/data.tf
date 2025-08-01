data "vault_kv_secret_v2" "this" {
  mount = split("-", "${terraform.workspace}")[length(split("-", "${terraform.workspace}")) - 1] == "prod" ? "shared-prod" : "shared-nonprod"
  name  = "vault-auth/${terraform.workspace}"
}