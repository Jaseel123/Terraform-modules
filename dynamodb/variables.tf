variable "name" {
  description = "Table Name"
  type        = string
  default     = ""
}

variable "billing_mode" {
  description = "Either PROVISIONED or PAY_PER_REQUEST"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "deletion_protection_enabled" {
  description = "Enables deletion protection for table"
  type        = bool
  default     = false
}

variable "hash_key" {
  description = "Partition Key Name. Attribute for same has to be set in attributes block - String(S) / Number(N) / Binary(N)"
  type        = string
  default     = null
}

variable "range_key" {
  description = "Sort Key Name. Attribute for same has to be set in attributes block - String(S) / Number(N) / Binary(N)"
  type        = string
  default     = null
}

variable "read_capacity" {
  description = "Read Capacity Units, required only if the billing_mode is PROVISIONED"
  type        = number
  default     = null
}

variable "write_capacity" {
  description = "Write Capacity Units, required only if the billing_mode is PROVISIONED"
  type        = number
  default     = null
}

variable "stream_enabled" {
  description = "Enable / Disable streams for table"
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "Stream view type - valid values are KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES, required only if stream is enabled"
  type        = string
  default     = null
}

variable "table_class" {
  description = "Storage class for table - STANDARD / STANDARD_INFREQUENT_ACCESS"
  type        = string
  default     = "STANDARD"
}

variable "ttl_enabled" {
  description = "Enable / Disable TTL"
  type        = bool
  default     = false
}

variable "ttl_attribute_name" {
  description = "Table attribute name to store ttl"
  type        = string
  default     = ""
}

variable "point_in_time_recovery_enabled" {
  description = "Enable / Disable Point in time recovery"
  type        = bool
  default     = false
}

variable "attributes" {
  description = "List of nested attribute definitions for hash_key and range_key attributes. Each attribute should have two properties: name - (Required) The name of the attribute, type - (Required) Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data"
  type        = list(map(string))
  default     = []
}

variable "local_secondary_indexes" {
  description = "Local Secondary Indexes"
  type        = any
  default     = []
}

variable "global_secondary_indexes" {
  description = "Global Secondary Indexes"
  type        = any
  default     = []
}

variable "replica_regions" {
  description = "Regions for replica"
  type        = any
  default     = []
}

variable "server_side_encryption_enabled" {
  description = "Enable / Disable Server Side Encryption"
  type        = bool
  default     = true
}

variable "server_side_encryption_kms_key_arn" {
  description = "Arn of KMS Key for encryption"
  type        = string
  default     = ""
}

variable "import_table" {
  description = "Configuration for importing s3 data into table"
  type        = any
  default     = {}
}

variable "tags" {
  description = "Madatory Tags"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Resource Management Timeouts"
  type        = map(string)
  default = {
    create = "10m"
    update = "60m"
    delete = "10m"
  }
}