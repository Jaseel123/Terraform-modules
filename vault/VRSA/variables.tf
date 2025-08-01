variable "role_bindings" {
  type        = any
  description = "Role binding configs"
  default     = []
}

variable "vault_auth_backend_path" {
  type = string
}