data "aws_iam_policy_document" "combined" {
  source_policy_documents = concat(
    length(try(var.policies.s3_read, [])) > 0 ? [data.aws_iam_policy_document.s3_read[0].json] : [],
    length(try(var.policies.s3_read_write, [])) > 0 ? [data.aws_iam_policy_document.s3_read_write[0].json] : [],
    length(try(var.policies.kms_encrypt_decrypt, [])) > 0 ? [data.aws_iam_policy_document.kms_encrypt_decrypt[0].json] : [],
    length(try(var.policies.dynamodb_read_write, [])) > 0 ? [data.aws_iam_policy_document.dynamodb_read_write[0].json] : [],
    length(try(var.policies.dynamodb_read, [])) > 0 ? [data.aws_iam_policy_document.dynamodb_read[0].json] : [],
    length(try(var.policies.ivs_read_write, [])) > 0 ? [data.aws_iam_policy_document.ivs_read_write[0].json] : [],
    length(try(var.policies.elasticache_read_write, [])) > 0 ? [data.aws_iam_policy_document.elasticache_read_write[0].json] : [],
    length(try(var.policies.personalize_read_write, [])) > 0 ? [data.aws_iam_policy_document.personalize_read_write[0].json] : [],
    length(try(var.policies.neptunedb_connect, [])) > 0 ? [data.aws_iam_policy_document.neptunedb_connect[0].json] : [],
    length(try(var.policies.ecr_read_write, [])) > 0 ? [data.aws_iam_policy_document.ecr_read_write[0].json] : [],
    length(try(var.policies.autoscale_read_write, [])) > 0 ? [data.aws_iam_policy_document.autoscale_read_write[0].json] : [],
    length(try(var.policies.assume_role, [])) > 0 ? [data.aws_iam_policy_document.assume_role[0].json] : []
  )
}


data "aws_iam_policy_document" "s3_read" {
  count = length(try(var.policies.s3_read, [])) > 0 ? 1 : 0
  statement {

    effect = "Allow"

    resources = concat(
      [for bucket_name in var.policies.s3_read : format("arn:aws:s3:::%s", bucket_name)],
      [for bucket_name in var.policies.s3_read : format("arn:aws:s3:::%s/*", bucket_name)]
    )

    actions = [
      "s3:ListBucket",
      "s3:GetObject*",
    ]
  }
}

data "aws_iam_policy_document" "s3_read_write" {
  count = length(try(var.policies.s3_read_write, [])) > 0 ? 1 : 0
  statement {

    effect = "Allow"

    resources = concat(
      [for bucket_name in var.policies.s3_read_write : format("arn:aws:s3:::%s", bucket_name)],
      [for bucket_name in var.policies.s3_read_write : format("arn:aws:s3:::%s/*", bucket_name)]
    )

    actions = [
      "s3:ListBucket",
      "s3:*Object",
      "s3:GetLifecycleConfiguration",
      "s3:PutLifecycleConfiguration",
      "s3:PutObjectTagging",
      "s3:GetObjectTagging",
      "s3:DeleteObjectTagging",
      "s3:GetBucketAcl"
    ]
  }
}

data "aws_iam_policy_document" "kms_encrypt_decrypt" {
  count = length(try(var.policies.kms_encrypt_decrypt, [])) > 0 ? 1 : 0
  statement {
    effect = "Allow"

    resources = [for key in var.policies.kms_encrypt_decrypt : format("%s", key)]


    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
  }
}

data "aws_iam_policy_document" "dynamodb_read_write" {
  count = length(try(var.policies.dynamodb_read_write, [])) > 0 ? 1 : 0
  statement {

    effect = "Allow"

    resources = concat(
      [for table in var.policies.dynamodb_read_write : format("%s", table)],
      [for table in var.policies.dynamodb_read_write : format("%s/*", table)]
    )

    actions = [
      "dynamodb:ListTables",
      "dynamodb:ListTagsOfResource",
      "dynamodb:DescribeTable",
      "dynamodb:DescribeLimits",
      "dynamodb:DescribeTimeToLive",
      "dynamodb:DescribeReservedCapacityOfferings",
      "dynamodb:DescribeReservedCapacity",
      "dynamodb:BatchGetItem",
      "dynamodb:BatchWriteItem",
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:GetRecords",
      "dynamodb:PutItem",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:Scan",
      "dynamodb:TagResource",
      "dynamodb:UntagResource"
    ]
  }
}

data "aws_iam_policy_document" "dynamodb_read" {
  count = length(try(var.policies.dynamodb_read, [])) > 0 ? 1 : 0
  statement {

    effect = "Allow"

    resources = concat(
      [for table in var.policies.dynamodb_read : format("%s", table)],
      [for table in var.policies.dynamodb_read : format("%s/*", table)]
    )

    actions = [
      "dynamodb:ListGlobalTables",
      "dynamodb:ListTables",
      "dynamodb:BatchGetItem",
      "dynamodb:ConditionCheckItem",
      "dynamodb:PartiQLSelect",
      "dynamodb:DescribeTable",
      "dynamodb:DescribeGlobalTable",
      "dynamodb:GetShardIterator",
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:GetRecords"
    ]
  }
}

data "aws_iam_policy_document" "ivs_read_write" {
  count = length(try(var.policies.ivs_read_write, [])) > 0 ? 1 : 0
  statement {

    effect = "Allow"

    resources = concat(
      [for ivs in var.policies.ivs_read_write : format("%s", ivs)]
    )

    actions = [
      "ivs:TagResource",
      "ivs:CreateChannel",
      "ivs:CreateStreamKey",
      "ivs:ListStreams",
      "ivs:CreateStage",
      "ivs:DeleteStage",
      "ivsChat:CreateRoom",
      "ivsChat:CreateChatToken",
      "ivsChat:DeleteRoom",
      "ivschat:TagResource"
    ]
  }
}

data "aws_iam_policy_document" "elasticache_read_write" {
  count = length(try(var.policies.elasticache_read_write, [])) > 0 ? 1 : 0
  statement {

    effect = "Allow"

    resources = concat(
      [for elasticache in var.policies.elasticache_read_write : format("%s", elasticache)]
    )

    actions = [
      "elasticache:DescribeServerlessCaches",
      "elasticache:RemoveTagsFromResource",
      "elasticache:DescribeCacheParameters",
      "elasticache:DescribeCacheParameterGroups",
      "elasticache:Connect",
      "elasticache:AddTagsToResource",
      "elasticache:DescribeCacheClusters",
      "elasticache:ListTagsForResource"
    ]
  }
}

data "aws_iam_policy_document" "personalize_read_write" {
  count = length(try(var.policies.personalize_read_write, [])) > 0 ? 1 : 0
  statement {

    effect = "Allow"

    resources = concat(
      [for personalize in var.policies.personalize_read_write : format("%s", personalize)]
    )

    actions = [
      "personalize:GetRecommendations",
      "personalize:PutEvents",
      "personalize:PutUsers",
      "personalize:PutItems"
    ]
  }
}

data "aws_iam_policy_document" "neptunedb_connect" {
  count = length(try(var.policies.neptunedb_connect, [])) > 0 ? 1 : 0
  statement {

    effect = "Allow"

    resources = concat(
      [for neptunedb in var.policies.neptunedb_connect : format("%s", neptunedb)]
    )

    actions = [
      "neptune-db:connect"
    ]
  }
}

data "aws_iam_policy_document" "ecr_read_write" {
  count = length(try(var.policies.ecr_read_write, [])) > 0 ? 1 : 0

  statement {
    effect = "Allow"

    resources = concat(
      [for repo in var.policies.ecr_read_write : format("%s", repo)]
    )

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:GetAuthorizationToken"
    ]
  }
}

data "aws_iam_policy_document" "autoscale_read_write" {
  count = length(try(var.policies.autoscale_read_write, [])) > 0 ? 1 : 0

  statement {
    effect = "Allow"

    resources = ["*"]

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeTags",
      "ec2:DescribeImages",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:GetInstanceTypesFromInstanceRequirements",
      "eks:DescribeNodegroup",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup"
    ]
  }
}

data "aws_iam_policy_document" "assume_role" {
  count = length(try(var.policies.assume_role, [])) > 0 ? 1 : 0

  statement {
    effect = "Allow"

    resources = concat(
      [for role in var.policies.assume_role : format("%s", role)]
    )

    actions = [
      "sts:AssumeRole"
    ]
  }
}