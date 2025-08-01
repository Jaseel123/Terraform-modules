variable "enable_custom_config" {
  description = "Enable / disable custom configuration properties"
  type        = bool
}

variable "cluster_name" {
  description = "Name of Cluster"
  type        = string
}

variable "config_description" {
  description = "Description for custom configuration"
  type        = string
}

variable "kafka_version" {
  description = "Version of Kafka"
  type        = string
}

variable "config_properties" {
  description = "Server properties for custom configuration"
  type        = any
}

variable "number_of_broker_nodes" {
  description = "Number of Broker nodes"
  type        = number
}

variable "broker_node_instance_type" {
  description = "Instance type for Broker nodes"
  type        = string
}

variable "broker_node_security_groups" {
  description = "Security groups for Broker nodes"
  type        = list(string)
}

variable "broker_node_subnets" {
  description = "Subnets for Broker nodes"
  type        = list(string)
}

variable "broker_node_connectivity_info" {
  description = "Cluster access configuration - Public / Internal VPC"
  type        = any
  default     = {}
}

variable "timeouts" {
  description = "timeout configuration"
  type        = any
  default     = {}
}


variable "broker_node_storage_info" {
  description = "Storage information for broker nodes"
  type        = any
  default     = {}
}

variable "client_authentication" {
  description = "Client authentication configuration"
  type        = any
  default     = {}
}

variable "storage_mode" {
  description = "Storage mode for supported storage tiers - LOCAL / TIERED"
  type        = string
  default     = null
}

variable "kms_key_arn" {
  description = "ARN of KMS Key for encryption"
  type        = string
}

variable "client_broker_comm_encryption" {
  description = "Encryption between client & broker - TLS / TLS_PLAINTEXT / PLAINTEXT"
  type        = string
}

variable "internal_broker_comm_encryption" {
  description = "Encryption between broker nodes"
  type        = bool
}

variable "broker_node_az_distribution" {
  description = "Distribution of broker nodes across availability zones - DEFAULT"
  type        = string
  default     = "DEFAULT"
}

variable "enhanced_monitoring" {
  description = "Enhanced Monitoring - DEFAULT / PER_BROKER / PER_TOPIC_PER_BROKER / PER_TOPIC_PER_PARTITION"
  type        = string
  default     = "DEFAULT"
}

variable "cloudwatch_logs_enabled" {
  description = "Enable / Disable logs to Cloudwatch"
  type        = bool
  default     = false
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Retention days"
  type        = number
  default     = 7
}

variable "cloudwatch_log_group" {
  description = "Name of CloudWatch Log group"
  type        = string
}

variable "firehose_logs_enabled" {
  description = "Enable / Disable logs to Firehouse"
  type        = bool
  default     = false
}

variable "firehose_delivery_stream" {
  description = "Name of Firehouse Delivery Stream"
  type        = string
}

variable "s3_logs_enabled" {
  description = "Enable / Disable logs to S3"
  type        = bool
  default     = false
}

variable "s3_logs_bucket" {
  description = "Name of S3 bucket"
  type        = string
}

variable "s3_logs_prefix" {
  description = "Prefix for s3 logs"
  type        = string
}

variable "jmx_exporter_enabled" {
  description = "Enable / Disable Jmx exporter for brokers"
  type        = bool
}

variable "node_exporter_enabled" {
  description = "Enable / Disable Node exporter for brokers"
  type        = bool
}

variable "enable_resource_based_policy" {
  description = "Enable / Disable resource based policy"
  type        = bool
}

variable "cluster_source_policy_documents" {
  description = "IAM Source Policy Documents"
  type        = any
  default     = {}
}

variable "cluster_override_policy_documents" {
  description = "IAM Override Policy Documents"
  type        = any
  default     = {}
}

variable "cluster_policy_statements" {
  description = "Custom IAM Policy Statements"
  type        = any
  default     = {}
}

variable "tags" {
  description = "Mandatory Tags"
  type        = map(string)
  default     = {}
}
