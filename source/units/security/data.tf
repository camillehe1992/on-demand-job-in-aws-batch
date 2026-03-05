# data "aws_iam_policy_document" "role_policy" {
#   statement {
#     effect  = "Allow"
#     actions = ["secretsmanager:GetSecretValue"]
#     resources = [
#       "arn:${local.aws_partition}:secretsmanager:${local.aws_region}:${local.aws_account_id}:secret:${local.resource_prefix}-*"
#     ]
#     condition {
#       test     = "StringEquals"
#       variable = "secretsmanager:ResourceTag/environment"
#       values   = [var.env]
#     }
#   }
# }

data "aws_iam_policy_document" "cw_event_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["batch:SubmitJob"]
    resources = [
      "arn:${local.aws_partition}:batch:${local.aws_region}:${local.aws_account_id}:job-definition/${local.resource_prefix}-*",
      "arn:${local.aws_partition}:batch:${local.aws_region}:${local.aws_account_id}:job-queue/${local.resource_prefix}-*"
    ]
    condition {
      test     = "StringEquals"
      variable = "batch:ResourceTag/environment"
      values   = [var.env]
    }
  }
}
