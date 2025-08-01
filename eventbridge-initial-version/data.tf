data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

data "aws_cloudwatch_event_bus" "this" {
  count = var.create_bus ? 0 : 1

  name = var.bus_name
}

data "aws_iam_policy_document" "sfn" {
  count = var.attach_sfn_policy ? 1 : 0

  statement {
    sid       = "StepFunctionAccess"
    effect    = "Allow"
    actions   = ["states:StartExecution"]
    resources = var.sfn_target_arns
  }
}

data "aws_iam_policy_document" "assume_role" {
  count = var.create_role ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}


