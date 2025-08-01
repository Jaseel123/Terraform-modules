variable "name" {
  type = string
}

variable "efs_performance_mode" {
  description = "Performance mode for EFS"
  type        = string
  default     = "generalPurpose"
}


variable "kms_key_id" {
  type = string
}

variable "efs_throughput_mode" {
  description = "Throughput mode for EFS"
  type        = string
  default     = "bursting"
}


variable "provisioned_throughput_in_mibps" {
  description = "Throughput in Mibps"
  type        = number
  default     = 100
}


variable "lifecycle_policy" {
  description = "Lifecycle policy for EFS"
  type        = any
}

variable "mount_target" {
  description = "Configuration for EFS mount targets"
  type = object({
    subnet_ids      = list(string)
    security_groups = list(string)
  })
  default = {
    subnet_ids      = []
    security_groups = []
  }
}


variable "tags" {
  description = "Default tags"
  type        = map(string)
}








