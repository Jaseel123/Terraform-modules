variable "create_bus" {
  description = "Controls whether EventBridge Bus resource should be created"
  type        = bool
  default     = true
}

variable "bus_name" {
  description = "A unique name forEventBridge Bus"
  type        = string
  default     = "default"
}

variable "rules" {
  description = "A map of objects with EventBridge Rule definitions."
  type        = map(any)
  default     = {}
}

variable "append_rule_postfix" {
  description = "Controls whether to append '-rule' to the name of the rule"
  type        = bool
  default     = true
}

variable "targets" {
  description = "A map of objects with EventBridge Target definitions."
  type        = any
  default     = {}
}

variable "event_source_name" {
  description = "The partner event source that the new event bus will be matched with. Must match name."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "create_rules" {
  description = "Controls whether EventBridge Rule resources should be created"
  type        = bool
  default     = true
}

variable "create_targets" {
  description = "Controls whether EventBridge Target resources should be created"
  type        = bool
  default     = true
}

variable "attach_sfn_policy" {
  description = "Controls whether the StepFunction policy should be added to IAM role for EventBridge Target"
  type        = bool
  default     = false
}

variable "sfn_target_arns" {
  description = "The Amazon Resource Name (ARN) of the StepFunctions you want to use as EventBridge targets"
  type        = list(string)
  default     = []
}

variable "create_role" {
  description = "Controls whether IAM roles should be created"
  type        = bool
  default     = true
}

variable "role_name" {
  description = "Name of IAM role to use for EventBridge"
  type        = string
  default     = null
}

variable "role_description" {
  description = "Description of IAM role to use for EventBridge"
  type        = string
  default     = null
}