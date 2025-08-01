variable "name" {
 description = "The name of the SQS queue"
 type        = string
}

variable "visibility_timeout_seconds" {
 description = "The visibility timeout for the queue."
 type        = number
 default     = 30
}

variable "tags" {
  description = "Mandatory Tags"
  type        = map(string)
  default     = {}
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes)"
  type        = number
  default     = 0
}


variable "kms_data_key_reuse_period_seconds" {
  description = "The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. An integer representing seconds, between 60 seconds (1 minute) and 86,400 seconds (24 hours)"
  type        = number
  default     = 300
}

variable "kms_master_key_id" {
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK"
  type        = string
  default     = null
}

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB)"
  type        = number
  default     = 262144
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  type        = number
  default     = 345600
}

variable "receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)"
  type        = number
  default     = 0
}

variable "redrive_allow_policy" {
  description = "The JSON policy to set up the Dead Letter Queue redrive permission, see AWS docs."
  type        = any
  default     = {}
}

# variable "redrive_policy" {
#   description = "The JSON policy to set up the Dead Letter Queue, see AWS docs. Note: when specifying maxReceiveCount, you must specify it as an integer (5), and not a string (\"5\")"
#   type        = any
#   default     = {}
# }

variable "sqs_managed_sse_enabled" {
  description = "Boolean to enable server-side encryption (SSE) of message content with SQS-owned encryption keys"
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

variable "enable_sns_policy" {
  description = "Enable / Disable sns policy"
  type        = bool
  default     = false
}

variable "enable_eventbridge_policy" {
  description = "Enable / Disable eventbridge policy"
  type        = bool
  default     = false
}