variable "cluster_name" {
  description = "Name of Cluster"
  type        = string
}

variable "cluster_mode" {
  description = "Mode of Cluster - Serverless / Provisioned"
  type        = string
}

variable "cluster_subnets" {
  description = "Subnets for Cluster"
  type        = list(string)
}

variable "cluster_azs" {
  description = "AZs for Cluster"
  type        = list(string)
}

variable "cluster_sgs" {
  description = "Security Groups for Cluster"
  type        = list(string)
}

variable "neptune_cluster_parameter_group_family" {
  description = "Cluster parameter group family"
  type        = string
}

variable "neptune_instance_parameter_group_family" {
  description = "Instance parameter group family"
  type        = string
}

variable "neptune_cluster_parameter_group_parameters" {
  description = "Cluster parameter group parameters"
  type        = any
}

variable "neptune_instance_parameter_group_parameters" {
  description = "Instance parameter group parameters"
  type        = any
}

variable "cluster_engine" {
  description = "Name of Cluster engine"
  type        = string
  default     = "neptune"
}

variable "cluster_engine_version" {
  description = "Version of Cluster engine"
  type        = string
}

variable "serverless_min_mem" {
  description = "Minimum required memory for Serverless engine"
  type        = string
  default     = "2.0"
}

variable "serverless_max_mem" {
  description = "Maximum required memory for Serverless engine"
  type        = string
  default     = "256.0"
}

variable "num_of_neptune_instances" {
  description = "Number of neptune instances"
  type        = number
}

variable "cluster_instance_type" {
  description = "Instance type of cluster"
  type        = string
}

variable "cluster_port" {
  description = "Custom cluster port number"
  type        = number
}

variable "cluster_iam_roles" {
  description = "IAM roles for authentication"
  type        = list(string)
}

variable "iam_database_authentication_enabled" {
  description = "Enable / disable IAM authentication"
  type        = bool
}

variable "publicly_accessible" {
  description = "Enable / disable public access"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Backup retention period"
  type        = number
}

variable "preferred_backup_window" {
  description = "Perferred backup window"
  type        = string
  default     = "07:00-09:00"
}

variable "snapshot_identifier" {
  description = "ARN of snapshot"
  type        = string
}

variable "final_snapshot_identifier" {
  description = "Name for final snapshot identifier"
  type        = string
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot"
  type        = bool
}

variable "storage_encrypted" {
  description = "Enable / Disable storage encryption"
  type        = bool
}

variable "kms_key" {
  description = "ARN of kms key"
  type        = string
}

variable "enable_cloudwatch_logs_exports" {
  description = "Log types to export to cloudwatch"
  type        = list(string)
}

variable "allow_major_version_upgrade" {
  description = "Allow major engine version upgrades when changing engine versions"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Allow minor engine version upgrades when changing engine versions"
  type        = bool
  default     = false
}

variable "preferred_maintenance_window" {
  description = "Maintenance window in UTC"
  type        = string
  default     = null
}

variable "apply_immediately" {
  description = "Apply Changes immediately or in next maintenance window"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Enable / Disable delete protection"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Mandatory Tags"
  type        = map(string)
  default     = {}
}
