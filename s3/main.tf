resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  bucket_prefix = var.bucket_prefix

  force_destroy = var.force_destroy
  tags          = var.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = try(var.lifecycle_policy.enabled, false) ? 1 : 0

  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_policy.rules

    content {
      id     = try(rule.value.id, null)
      status = rule.value.enabled ? "Enabled" : "Disabled"

      # Max 1 block - abort_incomplete_multipart_upload
      dynamic "abort_incomplete_multipart_upload" {
        for_each = try([rule.value.abort_incomplete_multipart_upload_days], [])

        content {
          days_after_initiation = try(rule.value.abort_incomplete_multipart_upload_days, null)
        }
      }


      # Max 1 block - expiration
      dynamic "expiration" {
        for_each = try(flatten([rule.value.expiration]), [])

        content {
          date                         = try(expiration.value.date, null)
          days                         = try(expiration.value.days, null)
          expired_object_delete_marker = try(expiration.value.expired_object_delete_marker, null)
        }
      }

      # Several blocks - transition
      dynamic "transition" {
        for_each = try(flatten([rule.value.transition]), [])

        content {
          date          = try(transition.value.date, null)
          days          = try(transition.value.days, null)
          storage_class = transition.value.storage_class
        }
      }

      # Max 1 block - noncurrent_version_expiration
      dynamic "noncurrent_version_expiration" {
        for_each = try(flatten([rule.value.noncurrent_version_expiration]), [])

        content {
          newer_noncurrent_versions = try(noncurrent_version_expiration.value.newer_noncurrent_versions, null)
          noncurrent_days           = try(noncurrent_version_expiration.value.days, noncurrent_version_expiration.value.noncurrent_days, null)
        }
      }

      # Several blocks - noncurrent_version_transition
      dynamic "noncurrent_version_transition" {
        for_each = try(flatten([rule.value.noncurrent_version_transition]), [])

        content {
          newer_noncurrent_versions = try(noncurrent_version_transition.value.newer_noncurrent_versions, null)
          noncurrent_days           = try(noncurrent_version_transition.value.days, noncurrent_version_transition.value.noncurrent_days, null)
          storage_class             = noncurrent_version_transition.value.storage_class
        }
      }

      # Max 1 block - filter - without any key arguments or tags
      dynamic "filter" {
        for_each = length(try(flatten([rule.value.filter]), [])) == 0 ? [true] : []

        content {
          #          prefix = ""
        }
      }

      # Max 1 block - filter - with one key argument or a single tag
      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(rule.value.filter.tags, rule.value.filter.tag, []))) == 1]

        content {
          object_size_greater_than = try(filter.value.object_size_greater_than, null)
          object_size_less_than    = try(filter.value.object_size_less_than, null)
          prefix                   = try(filter.value.prefix, null)

          dynamic "tag" {
            for_each = try(filter.value.tags, filter.value.tag, [])

            content {
              key   = tag.key
              value = tag.value
            }
          }
        }
      }

      # Max 1 block - filter - with more than one key arguments or multiple tags
      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(rule.value.filter.tags, rule.value.filter.tag, []))) > 1]

        content {
          and {
            object_size_greater_than = try(filter.value.object_size_greater_than, null)
            object_size_less_than    = try(filter.value.object_size_less_than, null)
            prefix                   = try(filter.value.prefix, null)
            tags                     = try(filter.value.tags, filter.value.tag, null)
          }
        }
      }
    }
  }

  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.this]
}


resource "aws_s3_bucket_server_side_encryption_configuration" "this" {

  bucket = aws_s3_bucket.this.id

  rule {
    bucket_key_enabled = true
    apply_server_side_encryption_by_default {
      sse_algorithm = try(var.encryption_mode, "AES256")
      kms_master_key_id = var.encryption_mode == "aws:kms" ? var.kms_key_arn : null
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {

  bucket = aws_s3_bucket.this.id

  block_public_acls       = try(var.public_access.block_public_acls, true)
  block_public_policy     = try(var.public_access.block_public_policy, true)
  ignore_public_acls      = try(var.public_access.ignore_public_acls, true)
  restrict_public_buckets = try(var.public_access.restrict_public_buckets, true)
}

resource "aws_s3_bucket_website_configuration" "this" {
  count = try(var.website_configuration.enabled, false) ? 1 : 0

  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = var.website_configuration.index_document
  }

  error_document {
    key = try(var.website_configuration.error_document, null)
  }

  dynamic "routing_rule" {
    for_each = try(flatten([var.website_configuration["routing_rules"]]), [])

    content {
      dynamic "condition" {
        for_each = try([routing_rule.value.condition], [])

        content {
          http_error_code_returned_equals = try(routing_rule.value.condition["http_error_code_returned_equals"], null)
          key_prefix_equals               = try(routing_rule.value.condition["key_prefix_equals"], null)
        }
      }

      redirect {
        host_name               = try(routing_rule.value.redirect["host_name"], null)
        http_redirect_code      = try(routing_rule.value.redirect["http_redirect_code"], null)
        protocol                = try(routing_rule.value.redirect["protocol"], null)
        replace_key_prefix_with = try(routing_rule.value.redirect["replace_key_prefix_with"], null)
        replace_key_with        = try(routing_rule.value.redirect["replace_key_with"], null)
      }
    }
  }
}

resource "aws_s3_bucket_notification" "this" {
  count = var.create_bucket_notification ? 1 : 0

  bucket = aws_s3_bucket.this.id

  dynamic "lambda_function" {
    for_each = var.lambda_notifications

    content {
      id                  = try(lambda_function.value.id, lambda_function.key)
      lambda_function_arn = lambda_function.value.function_arn
      events              = lambda_function.value.events
      filter_prefix       = try(lambda_function.value.filter_prefix, null)
      filter_suffix       = try(lambda_function.value.filter_suffix, null)
    }
  }

  dynamic "queue" {
    for_each = var.sqs_notifications

    content {
      id            = try(queue.value.id, queue.key)
      queue_arn     = queue.value.queue_arn
      events        = queue.value.events
      filter_prefix = try(queue.value.filter_prefix, null)
      filter_suffix = try(queue.value.filter_suffix, null)
    }
  }

  dynamic "topic" {
    for_each = var.sns_notifications

    content {
      id            = try(topic.value.id, topic.key)
      topic_arn     = topic.value.topic_arn
      events        = topic.value.events
      filter_prefix = try(topic.value.filter_prefix, null)
      filter_suffix = try(topic.value.filter_suffix, null)
    }
  }

  depends_on = [
    aws_lambda_permission.allow,
    aws_sqs_queue_policy.allow,
    aws_sns_topic_policy.allow,
  ]
}

# Lambda
resource "aws_lambda_permission" "allow" {
  for_each = var.lambda_notifications

  statement_id_prefix = "AllowLambdaS3BucketNotification-"
  action              = "lambda:InvokeFunction"
  function_name       = each.value.function_name
  qualifier           = try(each.value.qualifier, null)
  principal           = "s3.amazonaws.com"
  source_arn          = aws_s3_bucket.this.arn
  source_account      = try(each.value.source_account, null)
}

# SQS Queue
data "aws_arn" "queue" {
  for_each = var.sqs_notifications

  arn = each.value.queue_arn
}

data "aws_iam_policy_document" "sqs" {
  for_each = { for k, v in var.sqs_notifications : k => v if var.create_sqs_policy }

  statement {
    sid = "AllowSQSS3BucketNotification"

    effect = "Allow"

    actions = [
      "sqs:SendMessage",
    ]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    resources = [each.value.queue_arn]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_sqs_queue_policy" "allow" {
  for_each = { for k, v in var.sqs_notifications : k => v if var.create_sqs_policy }

  queue_url = try(each.value.queue_id, local.queue_ids[each.key], null)
  policy    = data.aws_iam_policy_document.sqs[each.key].json
}

# SNS Topic
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "sns" {
  for_each = { for k, v in var.sns_notifications : k => v if var.create_sns_policy }

  statement {
    sid = "AllowSNSS3BucketNotification"

    effect = "Allow"

    actions = [
      "sns:Publish",
    ]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    resources = [each.value.topic_arn]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_sns_topic_policy" "allow" {
  for_each = { for k, v in var.sns_notifications : k => v if var.create_sns_policy }

  arn    = each.value.topic_arn
  policy = data.aws_iam_policy_document.sns[each.key].json
}

resource "aws_s3_bucket_cors_configuration" "this" {
  count = try(var.cors.enabled, false) ? 1 : 0

  bucket                = aws_s3_bucket.this.id

  dynamic "cors_rule" {
    for_each = var.cors.rules

    content {
      id              = try(cors_rule.value.id, null)
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      allowed_headers = try(cors_rule.value.allowed_headers, null)
      expose_headers  = try(cors_rule.value.expose_headers, null)
      max_age_seconds = try(cors_rule.value.max_age_seconds, null)
    }
  }
}