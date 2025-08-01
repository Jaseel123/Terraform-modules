variable "bucket_name" {
  type        = string
  description = "Name of the bucket"
}

variable "bucket_prefix" {
  type        = string
  description = "Prefix to be added with the bucket name"
  default     = ""
}

variable "force_destroy" {
  type        = bool
  description = "enable force destroy for s3 bucket"
  default     = false
}

variable "public_access" {
  description = "Enable/disable public access"
  type        = map(string)
}

variable "encryption_mode" {
  description = "Encryption mode - AES256 / aws:kms / aws:kms:dsse"
  type        = string
  default = "AES256"
}

variable "kms_key_arn" {
  description = "KMS Key ARN"
  type        = string
  default = null
}

variable "lifecycle_policy" {
  description = "Lifecycle configuration for objects"
  type        = any
}

variable "website_configuration" {
  description = "Static website configuration"
  type        = any
}

variable "versioning_enabled" {
  description = "Enable versioning"
  type        = string
}

variable "tags" {
  description = "Default tags"
  type        = map(string)
}

variable "create_bucket_notification" {
  description = "Whether to create bucket notification"
  type        = bool
  default     = true
}

variable "lambda_notifications" {
  description = "Map of S3 bucket notifications to Lambda function"
  type        = any
  default     = {}
}

variable "sqs_notifications" {
  description = "Map of S3 bucket notifications to SQS queue"
  type        = any
  default     = {}
}

variable "sns_notifications" {
  description = "Map of S3 bucket notifications to SNS topic"
  type        = any
  default     = {}
}

variable "create_sns_policy" {
  description = "Whether to create a policy for SNS permissions or not?"
  type        = bool
  default     = true
}

variable "create_sqs_policy" {
  description = "Whether to create a policy for SQS permissions or not?"
  type        = bool
  default     = true
}

variable "cors" {
  description = "CORS Configuration for the bucket"
  type        = any
}