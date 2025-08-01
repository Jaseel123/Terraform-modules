variable "region" {
  type        = string
  description = "Region for the cluster"
}

variable "cluster_name" {
  type        = string
  description = "Name for the cluster"
}

variable "cluster_version" {
  description = "Version of the kubernetes cluster"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where cluster is provisoned"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs on the VPC where cluster is provisoned"
  type        = list(string)
}

variable "master_role" {
  description = "IAM role configuration for the master"
  type        = any
}

variable "worker_role" {
  description = "IAM role configuration for the workers"
  type        = any
}

variable "addons" {
  description = "Addons to be installed on the cluster"
  type        = any
}

variable "endpoint_access" {
  description = "Enable endpoint private/public access"
  type        = any
}

variable "sg" {
  description = "All security groups"
  type        = any
}

variable "sg_rules" {
  description = "All security group rules"
  type        = any
}

variable "user_data_path" {
  description = "Path to the userdata script"
  type        = string
}

variable "infra_nodegroup" {
  description = "Configurations for infra nodegroup"
  type        = any
}

variable "additional_nodegroups" {
  description = "Configurations for additional dynamic nodegroups"
  type = map(object({
    launch_template = object({
      version                 = number
      ami                     = string
      on_demand_instance_type = string
      spot_instance_types     = list(string)
      volume = object({
        size = number
        type = string
      })
      user_data_path = string
      subnet_ids     = list(string)
      scaling = object({
        desired = number
        min     = number
        max     = number
      })
      max_unavailable = number
    })
  }))
  default = {}
}

variable "worker_nodegroup" {
  description = "Configurations for worker nodegroup"
  type        = any
}

variable "enable_spot" {
  description = "Enable spot type for the nodegroups"
  type        = bool
}

variable "enable_efs" {
  description = "Enable / disable efs - storage class"
  type        = bool
  default     = false
}

variable "efs_performance_mode" {
  description = "Performance mode for EFS"
  type        = string
  default     = "generalPurpose"
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

variable "cluster_logs_retention" {
  description = "Log Retention for CloudWatch Log Group"
  type        = number
  default     = 3
}

variable "tags" {
  description = "Default tags"
  type        = map(string)
}
