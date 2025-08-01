variable "broker_name" {
  type = string
  description = "Name of the broker."
}

variable "engine_type" {
  type = string
  description = "Type of broker engine. Valid values are ActiveMQ and RabbitMQ"
  validation {
    condition = var.engine_type == "ActiveMQ" || var.engine_type == "RabbitMQ"
    error_message = "The engine type should be either ActiveMQ or RabbitMQ"
  }
}

variable "engine_version" {
  type = string
  description = "Version of the broker engine"
}

variable "host_instance_type" {
  type = string
  description = "Broker's instance type"
  validation {
    condition = substr(var.host_instance_type, 0, 2) == "mq"
    error_message = "The brokers instance type should be compatible"
  }
}

variable "mq_users" {
  type = list(object({
    console_access   = bool
    groups           = list(string)
    replication_user = bool
    username         = string
  }))
  default = []
  description = "Configuration block for broker users"
}

variable "vault_path" {
  description = "path rto store rds secrets"
}

variable "apply_immediately" {
  description = "Specifies whether any broker modifications are applied immediately"
}

variable "auto_minor_version_upgrade" {
  type = bool
  default = false
  description = "Whether to automatically upgrade to new minor versions of brokers as Amazon MQ makes releases available."
}

variable "data_replication_mode" {
  type = string
  default = ""
  description = "Defines whether this broker is a part of a data replication pair"
}

variable "data_replication_primary_broker_arn" {
  type = string
  description = "The Amazon Resource Name (ARN) of the primary broker that is used to replicate data from in a data replication pair, and is applied to the replica broker"
}

variable "deployment_mode" {
  type = string
  default = "SINGLE_INSTANCE"
  description = "Deployment mode of the broker"
  validation {
    condition = contains(["SINGLE_INSTANCE", "ACTIVE_STANDBY_MULTI_AZ", "CLUSTER_MULTI_AZ"], var.deployment_mode)
    error_message = "Valid values are SINGLE_INSTANCE, ACTIVE_STANDBY_MULTI_AZ, and CLUSTER_MULTI_AZ"
  }
}

variable "kms_key_id" {
  type = string
  description = "Amazon Resource Name (ARN) of Key Management Service (KMS) Customer Master Key (CMK) to use for encryption at rest"
}

variable "audit_log_enabled" {
  type = bool
  default = false
  description = "Enables audit logging"
}

variable "general_log_enabled" {
  type = bool
  default = false
  description = "Enables general logging via CloudWatch"
}

variable "maintenance_window" {
  type = object({
    day_of_week = string
    time_of_day = string
    time_zone   = string
  })
  description = "Specifies the start time of the maintenance window."
}

variable "publicly_accessible" {
  type = bool
  default = false
  description = "Whether to enable connections from applications outside of the VPC that hosts the broker's subnets"
}

variable "security_groups" {
  type = list(string)
  default = []
  description = "List of security group IDs assigned to the broker"
}

variable "subnet_ids" {
  type = list(string)
  default = []
  description = "List of subnet IDs in which to launch the broker. A SINGLE_INSTANCE deployment requires one subnet. An ACTIVE_STANDBY_MULTI_AZ deployment requires multiple subnets"
}

variable "configuration_data" {
  type        = string
  description = "The configuration data"
}

variable "tags" {
  description = "Madatory Tags"
  type        = map(string)
  default     = {}
}