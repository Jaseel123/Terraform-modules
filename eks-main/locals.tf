locals {
  managed_policy_prefix = "arn:aws:iam::aws:policy"
  common_tags = {
    managed_by   = "terraform"
    map-migrated = "d-server-023acc1pmutc1g"
    Project      = "${var.tags.project}"
    Product      = "${var.tags.product}"
    Environment  = "${var.tags.environment}"
    Maintainer   = "DevOps"
    CostCenter   = "${var.tags.costcenter}"
  }
}