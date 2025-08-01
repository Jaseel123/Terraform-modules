resource "aws_api_gateway_rest_api" "this" {
  name                         = var.name
  disable_execute_api_endpoint = var.disable_execute_api_endpoint
  binary_media_types           = var.binary_media_types
  tags                         = var.tags

  endpoint_configuration {
    types = [var.endpoint_type]
  }
}

resource "aws_api_gateway_account" "this" {
  cloudwatch_role_arn = var.enable_custom_role ? aws_iam_role.this[0].arn : var.existing_role_arn
}

resource "aws_iam_role" "this" {
  count              = var.enable_custom_role ? 1 : 0
  name               = "${var.name}-role"
  assume_role_policy = data.aws_iam_policy_document.this_trust.json
  tags               = var.tags
}

resource "aws_iam_role_policy" "this" {
  count              = var.enable_custom_role ? 1 : 0
  name               = "${var.name}-custom-policy"
  role               = aws_iam_role.this[0].id
  policy             = data.aws_iam_policy_document.this_policy.json
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/apigateway/${var.name}"
  retention_in_days = var.log_group_retention
  kms_key_id        = var.kms_key_arn
  tags              = var.tags
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  deployment_id        = aws_api_gateway_deployment.this.id
  rest_api_id          = aws_api_gateway_rest_api.this.id
  stage_name           = var.stage_name
  xray_tracing_enabled = var.xray_tracing_enabled

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.this.arn
    format          = replace(var.access_log_format, "\n", "")
  }

  variables = {
    vpc_link_id = var.enable_vpc_link ? aws_api_gateway_vpc_link.this[0].id : var.existing_vpc_link_id
  }

  tags = var.tags
}

resource "aws_api_gateway_resource" "this" {
  for_each = var.api_gw_resources

  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = each.key
}

resource "aws_api_gateway_method" "this" {
  for_each = var.api_gw_resources

  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.this[each.key].id
  http_method   = each.value.method
  authorization = each.value.authorization
}

resource "aws_api_gateway_integration" "this" {
  for_each = var.api_gw_integrations

  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.this[each.key].id
  http_method             = aws_api_gateway_method.this[each.key].http_method
  integration_http_method = aws_api_gateway_method.this[each.key].http_method
  type                    = "HTTP_PROXY"
  uri                     = each.value.uri
  connection_type         = "VPC_LINK"
  connection_id           = var.enable_vpc_link ? aws_api_gateway_vpc_link.this[0].id : var.existing_vpc_link_id
}

resource "aws_api_gateway_vpc_link" "this" {
  count       = var.enable_vpc_link ? 1 : 0
  name        = "${var.name}-vpc-link"
  description = "VPC Link for ${var.name}"
  target_arns = [data.aws_lb.this.arn]
}

resource "aws_api_gateway_domain_name" "this" {
  domain_name              = var.api_gw_domain
  regional_certificate_arn = var.acm_certificate_arn

  endpoint_configuration {
    types = [var.endpoint_type]
  }
}

resource "aws_api_gateway_base_path_mapping" "this" {
  api_id      = aws_api_gateway_rest_api.this.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  domain_name = aws_api_gateway_domain_name.this.domain_name
}