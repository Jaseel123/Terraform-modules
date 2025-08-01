resource "aws_media_convert_queue" "this" {
  name = var.name
  description = var.description
  pricing_plan = var.pricing_plan 
  status = var.status
  tags = var.tags
}