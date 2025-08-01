variable "bypass_policy_lockout_safety_check" {
  description = "Enable / Disable Bypassing Key policy"
  type        = bool
  default     = false
}

variable "customer_master_key_spec" {
  description = "Encryption / Signing Algorithms - `SYMMETRIC_DEFAULT`, `RSA_2048`, `RSA_3072`, `RSA_4096`, `HMAC_256`, `ECC_NIST_P256`, `ECC_NIST_P384`, `ECC_NIST_P521`, or `ECC_SECG_P256K1`"
  type        = string
  default     = "SYMMETRIC_DEFAULT"
}

variable "custom_key_store_id" {
  description = "Custom keystore like CloudHSM instead of KMS"
  type        = string
  default     = null
}

variable "deletion_window_in_days" {
  description = "Deletion window from date of key deletion"
  type        = number
  default     = 30
}

variable "description" {
  description = "Description for KMS key"
  type        = string
  default     = null
}

variable "enable_key_rotation" {
  description = "Enable / Disable Key rotation"
  type        = bool
  default     = true
}

variable "is_enabled" {
  description = "Enable / Disable key during provisioning"
  type        = bool
  default     = true
}

variable "key_usage" {
  description = "Usage of key - `ENCRYPT_DECRYPT` or `SIGN_VERIFY`"
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "multi_region" {
  description = "Enable / Disable Multi Region Key"
  type        = bool
  default     = false
}

variable "policy" {
  description = "Custom Key Policy document instead of using pre-populated policy"
  type        = string
  default     = null
}

variable "enable_default_policy" {
  description = "Enable / Disable default policy"
  type        = bool
  default     = true
}

variable "key_owners" {
  description = "List of Key Owners arn"
  type        = list(string)
  default     = []
}

variable "key_administrators" {
  description = "List of Key Administrators arn"
  type        = list(string)
  default     = []
}

variable "key_users" {
  description = "List of Key Users arn"
  type        = list(string)
  default     = []
}

variable "key_read_only_users" {
  description = "List of Key Read Only Users arn"
  type        = list(string)
  default     = []
}

variable "key_service_users" {
  description = "List of Key Service Users arn"
  type        = list(string)
  default     = []
}

variable "key_statements" {
  description = "IAM Policy statement for custom permissions"
  type        = any
  default     = {}
}

variable "alias_use_name_prefix" {
  description = "Enable / Disable alias name prefix"
  type        = bool
  default     = false
}

variable "key_alias" {
  description = "Alias name for key"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Mandatory Tags"
  type        = map(string)
  default     = {}
}