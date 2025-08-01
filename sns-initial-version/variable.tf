variable "kms_master_key_id" {
  type        = string
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK."
}

variable "name" {
 description = "The name of the sns topic"
 type        = string
}

variable "tags" {
  description = "Mandatory Tags"
  type        = map(string)
  default     = {}
}

variable "delivery_policy" {
  description = "delivery policy for sns"
  type        = string
  default     = null
}

variable "enable_default_policy" {
  description = "Enable / Disable default policy"
  type        = bool
  default     = true
}

variable "subscribers" {
  description = "subscribers"

}