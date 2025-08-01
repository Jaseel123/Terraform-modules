data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "this" {

  policy_id = "__default_policy_ID"

  dynamic "statement" {
    for_each = var.enable_default_policy ? [1] : []
    content {
      sid       = "Default"
      actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]
      resources = ["*"]
      
      principals {
        type        = "AWS"
        identifiers = ["*"]
      }
      effect = "Allow"
      condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
    
      values = [
        data.aws_caller_identity.current.account_id
      ]
    }

    }
  }
}

data "aws_lambda_function" "this" {
  for_each = {
    for subscriber in var.subscribers : subscriber.value => subscriber if subscriber.protocol == "lambda"
  }
  function_name = each.key
}

data "aws_sqs_queue" "this" {
  for_each = {
    for subscriber in var.subscribers : subscriber.value => subscriber if subscriber.protocol == "sqs"
  }
  name = each.key
}
