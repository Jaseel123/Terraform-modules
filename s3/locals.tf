locals {
  queue_ids = { for k, v in var.sqs_notifications : k => format("https://%s.%s.amazonaws.com/%s/%s", data.aws_arn.queue[k].service, data.aws_arn.queue[k].region, data.aws_arn.queue[k].account, data.aws_arn.queue[k].resource) if try(v.queue_id, "") == "" }
}