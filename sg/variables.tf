variable "vpc_id" {
  description = "ID of the VPC"
}


variable "security_group_name" {
  description = "Name of the security group"
}

variable "description" {
  description = "Description of the security group"
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type        = any
}

variable "egress_rules" {
  description = "List of egress rules for the security group"
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
    default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

variable "tags" {
  description = "Tags to apply to the RDS instance"
  type        = map(string)
}
