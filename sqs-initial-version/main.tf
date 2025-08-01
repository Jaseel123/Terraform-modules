resource "aws_sqs_queue" "this" {
  name                        = var.name
  visibility_timeout_seconds  = var.visibility_timeout_seconds
  delay_seconds                     = var.delay_seconds
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  kms_master_key_id                 = var.kms_master_key_id
  max_message_size                  = var.max_message_size
  message_retention_seconds         = var.message_retention_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  sqs_managed_sse_enabled           = var.kms_master_key_id != null ? null : var.sqs_managed_sse_enabled
  policy                            = coalesce(var.policy, data.aws_iam_policy_document.this.json)
  tags = var.tags
}
