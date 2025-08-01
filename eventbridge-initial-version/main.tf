resource "aws_cloudwatch_event_bus" "this" {
  count = var.create_bus ? 1 : 0

  name              = var.bus_name
  event_source_name = try(var.event_source_name, null)

  tags = var.tags
}


resource "aws_cloudwatch_event_rule" "this" {
  for_each = { for k, v in local.eventbridge_rules : v.name => v if var.create_rules }

  name        = each.value.Name
  name_prefix = lookup(each.value, "name_prefix", null)

  event_bus_name = var.create_bus ? aws_cloudwatch_event_bus.this[0].name : var.bus_name

  description         = lookup(each.value, "description", null)
  is_enabled          = lookup(each.value, "enabled", null)
  event_pattern       = lookup(each.value, "event_pattern", null)
  schedule_expression = lookup(each.value, "schedule_expression", null)
  role_arn            = lookup(each.value, "role_arn", null)
  state               = lookup(each.value, "state", null)

  tags = merge(var.tags, {
    Name = each.value.Name
  })
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = { for k, v in local.eventbridge_targets : v.name => v if var.create_targets }

  event_bus_name = var.create_bus ? aws_cloudwatch_event_bus.this[0].name : var.bus_name

  rule = each.value.Name
  arn  = each.value.arn

  target_id  = lookup(each.value, "target_id", null)
  input      = lookup(each.value, "input", null)
  input_path = lookup(each.value, "input_path", null)
  role_arn = can(length(each.value.attach_role_arn) > 0) ? each.value.attach_role_arn : (try(each.value.attach_role_arn, null) == true ? aws_iam_role.eventbridge[0].arn : null)

  dynamic "sqs_target" {
    for_each = lookup(each.value, "message_group_id", null) != null ? [true] : []

    content {
      message_group_id = each.value.message_group_id
    }
  }


  dynamic "input_transformer" {
    for_each = lookup(each.value, "input_transformer", null) != null ? [
      each.value.input_transformer
    ] : []

    content {
      input_paths    = input_transformer.value.input_paths
      input_template = chomp(input_transformer.value.input_template)
    }
  }

  dynamic "dead_letter_config" {
    for_each = lookup(each.value, "dead_letter_arn", null) != null ? [true] : []

    content {
      arn = each.value.dead_letter_arn
    }
  }

  dynamic "retry_policy" {
    for_each = lookup(each.value, "retry_policy", null) != null ? [
      each.value.retry_policy
    ] : []

    content {
      maximum_event_age_in_seconds = retry_policy.value.maximum_event_age_in_seconds
      maximum_retry_attempts       = retry_policy.value.maximum_retry_attempts
    }
  }

  depends_on = [aws_cloudwatch_event_rule.this]
}

resource "aws_iam_policy" "sfn" {
  count = var.attach_sfn_policy ? 1 : 0

  name   = "${var.bus_name}-sfn"
  policy = data.aws_iam_policy_document.sfn[0].json

  tags = merge({ Name = "${var.bus_name}-sfn" }, var.tags)
}

resource "aws_iam_policy_attachment" "sfn" {
  count = var.attach_sfn_policy ? 1 : 0

  name       = "${var.bus_name}-sfn"
  roles      = [aws_iam_role.eventbridge[0].name]
  policy_arn = aws_iam_policy.sfn[0].arn
}

resource "aws_iam_role" "eventbridge" {
  count = var.create_role ? 1 : 0

  name                  = local.role_name
  description           = var.role_description
  assume_role_policy    = data.aws_iam_policy_document.assume_role[0].json

  tags = merge({ Name = local.role_name }, var.tags)
}

# data "aws_iam_policy_document" "sns" {
#   for_each = { for k, v in local.eventbridge_targets : v.name => v if var.create_targets && startswith(v.arn, "arn:aws:sns:")}

#   statement {
#     sid = "AllowSNSS3BucketNotification"

#     effect = "Allow"

#     actions = [
#       "sns:Publish",
#     ]

#     principals {
#       type        = "Service"
#       identifiers = ["*"]
#     }

#     resources = [each.value.arn]

#     condition {
#       test     = "StringEquals"
#       variable = "aws:SourceAccount"
#       values   = [data.aws_caller_identity.current.account_id]
#     }
#   }
# }

# resource "aws_sns_topic_policy" "allow" {
#   for_each = { for k, v in local.eventbridge_targets : v.name => v if var.create_targets && startswith(v.arn, "arn:aws:sns:")}

#   arn    = each.value.arn
#   policy = data.aws_iam_policy_document.sns[each.key].json
# }
