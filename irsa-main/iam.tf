resource "aws_iam_role" "this" {
  name               = "oidc-role-${var.service_account}"
  assume_role_policy = data.aws_iam_policy_document.oidc_trust_policy.json
  tags               = var.tags
}

resource "aws_iam_policy" "this" {
  name   = "policy-${var.service_account}"
  policy = data.aws_iam_policy_document.combined.json
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
}