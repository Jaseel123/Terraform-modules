variable "rds_name" {
  description = "Name of the RDS instnace"
}

variable "apply_immediately" {
  description = "immediately apply the changes"
}

variable "identifier" {
  description = "Name of the RDS identifier"
}

variable "vault_path" {
  description = "path rto store rds secrets"
}

variable "db_parameter_group_name" {
  description = "Name of the DB parameter group"
}

variable "subnets" {
  description = "List of subnet IDs for subnet group"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC"
}

variable "subnet_group_name" {
  description = "Name of the DB subnet group"

}

variable "parametr_group_family" {
  description = "family type of the parameter group"
  default     = "mysql8.0"

}

variable "create_read_replica" {
  description = "Whether to create a read replica or not"
  type        = bool
  default     = false
}

variable "option_group_engine" {
  default     = "mysql"
  description = "Option group engine type, mysql,mariadb,oracle-se,sqlserver-se etc "
}

variable "options" {
  description = "A list of Options to apply"
  type        = any
  default     = []
}

variable "engine" {
  default     = "mysql"
  description = "engine of the RDS"
}


variable "option_group_engine_version" {
  default     = "8.0"
  description = "Option group engine type, mysql,mariadb,oracle-se,sqlserver-se etc "
}

variable "engine_version" {
  description = "Version of the database engine"
  default     = "8.0.35"
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
  default     = false
}

variable "performance_insights_retention_period" {
  description = "The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)."
  type        = number
  default     = 7
}

variable "backup_retention_window" {
  description = "The amount of time in days to retain backup."
  type        = number
  default     = 7
}

variable "rds_password_length" {
  description = "length of admin password"
  type        = number
  default     = 16
}

variable "performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Instance type for the RDS instance"
}

variable "replica_instance_type" {
  description = "Instance type for the RDS instance replica"
}

variable "encryption_at_rest" {
  description = "Whether encryption at rest should be enabled"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key ID for encryption"
}

variable "config_groups" {
  description = "Whether to create subnet, parameter, and option groups"
  type        = bool
  default     = true
}

variable "storage_type" {
  description = "One of standard (magnetic), gp2 (general purpose SSD), gp3 (general purpose SSD that needs iops independently) or io1 (provisioned IOPS SSD)"
  default     = "gp2"
}


variable "parameter_group_name" {
  description = "Name of the DB parameter group"
}

variable "parameters" {
  description = "The list of DB parameters"
  type        = list(map(string))
  default     = []
}

variable "option_group_name" {
  description = "Name of the DB parameter group"
}

variable "db_option_group_tags" {
  description = "Additional tags for the DB option group"
  type        = map(string)
  default     = {}
}

variable "db_parameter_group_tags" {
  description = "Additional tags for the  DB parameter group"
  type        = map(string)
  default     = {}
}

variable "db_subnet_group_tags" {
  description = "Additional tags for the DB subnet group"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to the RDS instance"
  type        = map(string)
}

variable "maintenance_window" {
  type        = string
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi' UTC "
  default     = "Sun:03:00-Sun:04:00"
}

variable "backup_window" {
  description = "The window to perform backups in"
  default     = "03:00-04:00"
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the RDS instance"
  type        = list(string)
}

variable "replica_security_group_ids" {
  description = "List of security group IDs to attach to the RDS instance replica"
  type        = list(string)
}

variable "storage_size" {
  description = "storage size of the RDS"
  default     = 100
}

variable "username" {
  description = "username for admin user"
  default     = "admin"
}

variable "allow_major_version_upgrade" {
  type        = string
  description = "Allow major version upgrade"
  default     = "false"
}

variable "auto_minor_version_upgrade" {
  type        = string
  description = "Allow automated minor version upgrade (e.g. from Postgres 8.5.3 to Postgres 8.5.4)"
  default     = "true"
}

variable "deletion_protection" {
  type        = string
  description = "If the DB instance should have deletion protection enabled"
  default     = true
}

variable "skip_final_snapshot" {
  type        = bool
  description = "Flag to enable final snapshot"
  default     = true
}

variable "final_snapshot_identifier" {
  type        = string
  description = "The name of your final DB snapshot when this DB instance is deleted"
  default     = null
}

variable "multi_az" {
  type        = bool
  description = "param to check if the DB to be in Multi AZ or not"
  default     = "false"
}

variable "port" {
  type        = number
  description = "The port on which the DB accepts connections."
  default     = 3306
}

variable "copy_tags_to_snapshot" {
  type        = string
  description = "Copy tags from DB to a snapshot"
  default     = "true"
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(any)
  description = "Export the logs to cloudwatch, supported values are for RDS for MySQL - audit | error | general | slowquery and for RDS for PostgreSQL - postgresql | upgrade"
  default     = []
}

variable "cloudwatch_log_group_export_kms_key_id" {
  type        = string
  description = "Encryption for log exports log group"
  default     = ""
}

variable "cloudwatch_log_retention" {
  type        = number
  description = "Number of days to retain logs"
  default     = 7
}
