resource "aws_sns_topic" "this" {
  name                        = var.name
  display_name                = replace(var.name, ".", "-") # dots are illegal in display names and for .fifo topics required as part of the name (AWS SNS by design)
  kms_master_key_id           = var.kms_master_key_id
  delivery_policy             = coalesce(var.delivery_policy, file("${path.module}/sns_delivery_policy.json"))
#   policy = coalesce(var.policy, data.aws_iam_policy_document.this.json)
  tags = var.tags
}

resource "aws_sns_topic_subscription" "lambda_subscriptions" {
   for_each = {
    for subscriber in var.subscribers : subscriber.value => subscriber if subscriber.protocol == "lambda"
  }
  topic_arn              = aws_sns_topic.this.arn
  protocol               = each.value.protocol
  endpoint               = data.aws_lambda_function.this[each.key].arn
  endpoint_auto_confirms = true
  raw_message_delivery   = false
}

resource "aws_sns_topic_subscription" "sqs_subscriptions" {
   for_each = {
    for subscriber in var.subscribers : subscriber.value => subscriber if subscriber.protocol == "sqs"
  }
  topic_arn              = aws_sns_topic.this.arn
  protocol               = each.value.protocol
  endpoint               = data.aws_sqs_queue.this[each.key].arn
  endpoint_auto_confirms = true
  raw_message_delivery   = false
}

resource "aws_sns_topic_subscription" "https_subscriptions" {
   for_each = {
    for subscriber in var.subscribers : subscriber.value => subscriber if subscriber.protocol == "https"
  }
  topic_arn              = aws_sns_topic.this.arn
  protocol               = each.value.protocol
  endpoint               = each.value.value
  endpoint_auto_confirms = false
  raw_message_delivery   = false
}

resource "aws_sns_topic_subscription" "email_subscriptions" {
   for_each = {
    for subscriber in var.subscribers : subscriber.value => subscriber if subscriber.protocol == "email"
  }
  topic_arn              = aws_sns_topic.this.arn
  protocol               = each.value.protocol
  endpoint               = each.value.value
  endpoint_auto_confirms = false
  raw_message_delivery   = false
}

resource "aws_lambda_permission" "with_sns" {

  for_each = {
    for subscriber in var.subscribers : subscriber.value => subscriber if subscriber.protocol == "lambda"
  }
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = each.value.value
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.this.arn
}

# resource "aws_sns_topic_subscription" "subscriptions" {
#    for_each = {
#     for subscriber in var.subscribers : subscriber.value => subscriber
#   }
#   topic_arn = aws_sns_topic.this.arn
#   protocol  = each.value.protocol
#   endpoint  = each.value.value
#   endpoint_auto_confirms = true
#   raw_message_delivery = false
# }
