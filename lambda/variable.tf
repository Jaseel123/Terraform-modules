variable "name" {
  description = "Name of the Lambda function"
  type        = string
}
variable "s3_bucket" {
  description = "Name of S the3 bucket containing the Lambda code"
  type        = string
}
variable "s3_key" {
  description = "S3 key of the Lambda code zip file "
  type        = string
}
variable "handler" {
  description = "Lambda function's handler"
  type        = string
}
variable "runtime" {
  description = "Lambda function runtime"
  type        = string
}
variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime."
  type        = number
  default     = 128
}
variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}
variable "environment_variables" {
  description = "A map that defines environment variables for the Lambda function."
  type        = map(string)
  default     = {}
}
variable "vpc_subnet_ids" {
  description = "List of subnet IDs associated with a VPC to host the lambda function"
  type        = list(string)
  default     = []
}
variable "vpc_security_group_ids" {
  description = "List of security group IDs associated with the V toPC host the lambda function"
  type        = list(string)
  default     = []
}

variable "managed_policy" {
  description = "List of Manged Policy Arns"
  type        = list(string)
  default     = []
}
variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
# variable "dead_letter_target_arn" {
#  description = "The ARN of an SNS topic or SQS queue to notify when an invocation fails."
#  type        = string
#  default     = ""
# }
# variable "tracing_config" {
#  description = "The tracing settings of the function. Used for AWS X-Ray."
#  type        = string
#  default     = null
# }

variable "ephemeral_storage" {
  description = "ephermal storage"
  type        = number
  default     = 512
}

variable "layer_name" {
  description = "Layer name"
  type        = string
}

variable "layer_runtimes" {
  description = "Supported runtimes for Layer"
  type        = list(string)
  default     = []
}

variable "layer_source_bucket" {
  description = "Bucket for layer's source"
  type        = string
}

variable "layer_source_bucket_key" {
  description = "Bucket key for layer's source"
  type        = string
}

variable "create_layer" {
  description = "Whether to create layer"
  type        = bool
  default     = false
}

variable "additional_policy" {
  description = "Additional Policy for Lambda"
  type        = any
  default     = null
}

variable "create_additional_policy" {
  description = "Whether to create additional policy"
  type        = bool
  default     = false
}

variable "create_lambda_permission" {
  description = "Whether to create lambda permission"
  type        = bool
  default     = false
}

variable "lambda_permission" {
  description = "Required permission for lambda"
  type        = string
}

variable "lambda_permission_principal" {
  description = "Source principal for lambda permission"
  type        = string
}

variable "lambda_permission_principal_arn" {
  description = "Source principal arn for lambda permission"
  type        = string
}