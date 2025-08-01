data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}


data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.enable_default_policy ? [1] : []
    content {
      sid       = "__owner_statement"
      actions   = ["SQS:*"]
      resources = ["*"]
      principals {
        type        = "AWS"
        identifiers = ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"]
      }
    }
  }
  dynamic "statement" {
    for_each = var.enable_sns_policy ? [1] : []
    content {
      sid       = "sns_policy"
      actions   = ["sqs:SendMessage"]
      resources = ["*"]
      principals {
        type        = "Service"
        identifiers = ["sns.amazonaws.com"]
      }
    }
  }
  dynamic "statement" {
    for_each = var.enable_eventbridge_policy ? [1] : []
    content {
      sid       = "AllowEventBridgeToSendMessage"
      actions   = ["sqs:SendMessage"]
      resources = ["*"]
      principals {
        type        = "Service"
        identifiers = ["events.amazonaws.com"]
      }
    }
  }
}