variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "access_logs" {
  description = "Map containing access logging configuration for load balancer"
  type        = map(string)
  default     = {}
}

variable "connection_logs" {
  description = "Map containing access logging configuration for load balancer"
  type        = map(string)
  default     = {}
}

variable "client_keep_alive" {
  description = "Client keep alive value in seconds. The valid range is 60-604800 seconds. The default is 3600 seconds."
  type        = number
  default     = null
}

variable "customer_owned_ipv4_pool" {
  description = "The ID of the customer owned ipv4 pool to use for this load balancer"
  type        = string
  default     = null
}

variable "desync_mitigation_mode" {
  description = "Determines how the load balancer handles requests that might pose a security risk to an application due to HTTP desync. Valid values are `monitor`, `defensive` (default), `strictest`"
  type        = string
  default     = null
}

variable "dns_record_client_routing_policy" {
  description = "Indicates how traffic is distributed among the load balancer Availability Zones. Possible values are any_availability_zone (default), availability_zone_affinity, or partial_availability_zone_affinity. Only valid for network type load balancers."
  type        = string
  default     = null
}

variable "drop_invalid_header_fields" {
  description = "Indicates whether HTTP headers with header fields that are not valid are removed by the load balancer (`true`) or routed to targets (`false`). The default is `true`. Elastic Load Balancing requires that message header names contain only alphanumeric characters and hyphens. Only valid for Load Balancers of type `application`"
  type        = bool
  default     = true
}

variable "enable_cross_zone_load_balancing" {
  description = "If `true`, cross-zone load balancing of the load balancer will be enabled. For application load balancer this feature is always enabled (`true`) and cannot be disabled. Defaults to `true`"
  type        = bool
  default     = true
}

variable "enable_deletion_protection" {
  description = "If `true`, deletion of the load balancer will be disabled via the AWS API. This will prevent Terraform from deleting the load balancer. Defaults to `true`"
  type        = bool
  default     = true
}

variable "enable_http2" {
  description = "Indicates whether HTTP/2 is enabled in application load balancers. Defaults to `true`"
  type        = bool
  default     = null
}

variable "enable_tls_version_and_cipher_suite_headers" {
  description = "Indicates whether the two headers (`x-amzn-tls-version` and `x-amzn-tls-cipher-suite`), which contain information about the negotiated TLS version and cipher suite, are added to the client request before sending it to the target. Only valid for Load Balancers of type `application`. Defaults to `false`"
  type        = bool
  default     = null
}

variable "enable_waf_fail_open" {
  description = "Indicates whether to allow a WAF-enabled load balancer to route requests to targets if it is unable to forward the request to AWS WAF. Defaults to `false`"
  type        = bool
  default     = null
}

variable "enable_xff_client_port" {
  description = "Indicates whether the X-Forwarded-For header should preserve the source port that the client used to connect to the load balancer in `application` load balancers. Defaults to `false`"
  type        = bool
  default     = null
}

variable "idle_timeout" {
  description = "The time in seconds that the connection is allowed to be idle. Only valid for Load Balancers of type `application`. Default: `60`"
  type        = number
  default     = null
}

variable "internal" {
  description = "If true, the LB will be internal. Defaults to `false`"
  type        = bool
  default     = null
}

variable "ip_address_type" {
  description = "The type of IP addresses used by the subnets for your load balancer. The possible values are `ipv4` and `dualstack`"
  type        = string
  default     = null
}

variable "load_balancer_type" {
  description = "The type of load balancer to create. Possible values are `application`, `gateway`, or `network`. The default value is `application`"
  type        = string
  default     = "application"
}

variable "enforce_security_group_inbound_rules_on_private_link_traffic" {
  description = "Indicates whether inbound security group rules are enforced for traffic originating from a PrivateLink. Only valid for Load Balancers of type network. The possible values are on and off."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the LB. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen"
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with `name`"
  type        = string
  default     = null
}

variable "preserve_host_header" {
  description = "Indicates whether the Application Load Balancer should preserve the Host header in the HTTP request and send it to the target without any change. Defaults to `false`"
  type        = bool
  default     = null
}

variable "security_groups" {
  description = "A list of security group IDs to assign to the LB"
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "A list of subnet IDs to attach to the LB. Subnets cannot be updated for Load Balancers of type `network`. Changing this value for load balancers of type `network` will force a recreation of the resource"
  type        = list(string)
  default     = null
}

variable "xff_header_processing_mode" {
  description = "Determines how the load balancer modifies the X-Forwarded-For header in the HTTP request before sending the request to the target. The possible values are `append`, `preserve`, and `remove`. Only valid for Load Balancers of type `application`. The default is `append`"
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Create, update, and delete timeout configurations for the load balancer"
  type        = map(string)
  default     = {}
}

variable "default_port" {
  description = "Default port used across the listener and target group"
  type        = number
  default     = 80
}

variable "default_protocol" {
  description = "Default protocol used across the listener and target group"
  type        = string
  default     = "HTTP"
}

variable "listeners" {
  description = "Map of listener configurations to create"
  type        = any
  default     = {}
}

variable "target_groups" {
  description = "Map of target group configurations to create"
  type        = any
  default     = {}
}

variable "vpc_id" {
  description = "Identifier of the VPC where the security group will be created"
  type        = string
  default     = null
}
