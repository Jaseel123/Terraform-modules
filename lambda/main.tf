resource "aws_lambda_function" "this" {
  function_name = var.name
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
  handler       = var.handler
  runtime       = var.runtime
  role          = aws_iam_role.iam_for_lambda.arn
  memory_size   = var.memory_size
  timeout       = var.timeout
  # Environment Variables
  environment {
    variables = var.environment_variables
  }

  # VPC Configurations
  vpc_config {
    subnet_ids         = var.vpc_subnet_ids
    security_group_ids = var.vpc_security_group_ids
  }
  # Letter Dead Config
  #  dead_letter_config {
  #    target_arn = var.dead_letter_target_arn
  #  }
  # Tracing Config
  #  tracing_config {
  #    mode = var.tracing_config
  #  }
  layers = var.create_layer ? [aws_lambda_layer_version.this[0].arn] : []
  ephemeral_storage {
    size = var.ephemeral_storage
  }
  logging_config {
    log_format       = "JSON"
    system_log_level = "INFO"
  }

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "lambda-log-group" {
  name              = "/aws/lambda/${var.name}"
  retention_in_days = 7
  tags              = var.tags
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "${var.name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "cloudwatch_policy" {
  name = "${var.name}-cloudwatch-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogStream"
        ]
        Effect = "Allow"
        "Resource" : [
          "${aws_cloudwatch_log_group.lambda-log-group.arn}",
          "${aws_cloudwatch_log_group.lambda-log-group.arn}:log-stream:*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda_policy_attach1" {
  name       = "${var.name}-cloudwatch-policy-attachment"
  roles      = [aws_iam_role.iam_for_lambda.name]
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
}

resource "aws_iam_policy" "this" {
  count = var.create_additional_policy ? 1 : 0

  name   = "${var.name}-additional-policy"
  policy = jsonencode(var.additional_policy)
}

resource "aws_iam_policy_attachment" "this" {
  count = var.create_additional_policy ? 1 : 0

  name       = "${var.name}-additional-policy-attachment"
  roles      = [aws_iam_role.iam_for_lambda.name]
  policy_arn = aws_iam_policy.this[0].arn
}

resource "aws_iam_role_policy_attachment" "lambda_managed_policy_attach" {
  for_each   = toset(var.managed_policy)
  policy_arn = each.key
  role       = aws_iam_role.iam_for_lambda.name
}

resource "aws_lambda_layer_version" "this" {
  count = var.create_layer ? 1 : 0

  layer_name          = var.layer_name
  compatible_runtimes = var.layer_runtimes
  s3_bucket           = var.layer_source_bucket
  s3_key              = var.layer_source_bucket_key
}

resource "aws_lambda_permission" "this" {
  count = var.create_lambda_permission ? 1 : 0

  action        = var.lambda_permission
  function_name = aws_lambda_function.this.function_name
  principal     = var.lambda_permission_principal
  source_arn    = var.lambda_permission_principal_arn
}