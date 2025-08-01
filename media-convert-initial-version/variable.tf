variable "name" {
 description = "The name of the media convert queue"
 type        = string
}
variable "description" {
 description = "description"
 type        = string
}
variable "pricing_plan" {
 description = "pricing plan for the queue"
 type        = string
 default = "ON_DEMAND"
}
variable "status" {
 description = "status of the queue"
 type        = string
 default = "ACTIVE"
}
variable "tags" {
  description = "Mandatory Tags"
  type        = map(string)
  default     = {}
}
