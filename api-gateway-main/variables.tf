variable "name" {
  type    = string
  default = ""
}

variable "disable_execute_api_endpoint" {
  type    = bool
  default = true
}

variable "binary_media_types" {
  type    = any
  default = []
}

variable "endpoint_type" {
  type        = string
  description = "Endpoint type - EDGE / REGIONAL / PRIVATE"
  default     = "REGIONAL"
}

variable "log_group_retention" {
  type    = number
  default = 7
}

variable "stage_name" {
  type    = string
  default = ""
}

variable "access_log_format" {
  description = "The format of the access log file"
  type        = string
  default     = <<EOF
  {
	  "requestTime": "$context.requestTime",
	  "requestId": "$context.requestId",
	  "httpMethod": "$context.httpMethod",
	  "path": "$context.path",
	  "resourcePath": "$context.resourcePath",
	  "status": $context.status,
    "responseLatency": $context.responseLatency,
    "xrayTraceId": "$context.xrayTraceId",
    "integrationRequestId": "$context.integration.requestId",
    "functionResponseStatus": "$context.integration.status",
    "integrationLatency": "$context.integration.latency",
    "integrationServiceStatus": "$context.integration.integrationStatus",
    "authorizeResultStatus": "$context.authorize.status",
    "authorizerServiceStatus": "$context.authorizer.status",
    "authorizerLatency": "$context.authorizer.latency",
    "authorizerRequestId": "$context.authorizer.requestId",
    "ip": "$context.identity.sourceIp",
    "userAgent": "$context.identity.userAgent",
    "principalId": "$context.authorizer.principalId",
    "cognitoUser": "$context.identity.cognitoIdentityId",
    "user": "$context.identity.user"
  }
  EOF
}

variable "xray_tracing_enabled" {
  type    = bool
  default = false
}

variable "enable_vpc_link" {
  type    = bool
  default = true
}

variable "nlb_arn" {
  type    = string
  default = ""
}

variable "api_gw_resources" {
  type    = any
  default = {}
}

variable "api_gw_integrations" {
  type    = any
  default = {}
}

variable "api_gw_domain" {
  type    = string
  default = ""
}

variable "acm_certificate_arn" {
  type    = string
  default = ""
}

variable "kms_key_arn" {
  type    = string
  default = ""
}

variable "existing_vpc_link_id" {
  type    = string
  default = ""
}

variable "enable_custom_role" {
  type    = bool
  default = true
}

variable "existing_role_arn" {
  type    = string
  default = ""
}

variable "tags" {
  description = "Madatory Tags"
  type        = map(string)
  default     = {}
}