resource "aws_kms_key" "this" {

  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
  customer_master_key_spec           = var.customer_master_key_spec
  custom_key_store_id                = var.custom_key_store_id
  deletion_window_in_days            = var.deletion_window_in_days
  description                        = var.description
  enable_key_rotation                = var.enable_key_rotation
  is_enabled                         = var.is_enabled
  key_usage                          = var.key_usage
  multi_region                       = var.multi_region
  policy                             = coalesce(var.policy, data.aws_iam_policy_document.this.json)

  tags = var.tags
}

resource "aws_kms_alias" "this" {
  name          = var.alias_use_name_prefix ? null : "alias/${var.key_alias}"
  name_prefix   = var.alias_use_name_prefix ? "alias/${var.key_alias}-" : null
  target_key_id = aws_kms_key.this.key_id
}