data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "batch_instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "role_policy" {
  statement {
    effect  = "Allow"
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      "arn:${data.aws_partition.current.partition}:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:${var.env}-${var.nickname}-*"
    ]
    condition {
      test     = "StringEquals"
      variable = "secretsmanager:ResourceTag/environment"
      values   = [var.env]
    }
  }
}

data "aws_iam_policy_document" "ecs_tasks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "events_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cw_event_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["batch:SubmitJob"]
    resources = [
      "arn:${data.aws_partition.current.partition}:batch:${var.aws_region}:${data.aws_caller_identity.current.account_id}:job-definition/${var.env}-${var.nickname}-*",
      "arn:${data.aws_partition.current.partition}:batch:${var.aws_region}:${data.aws_caller_identity.current.account_id}:job-queue/${var.env}-${var.nickname}-*"
    ]
    condition {
      test     = "StringEquals"
      variable = "batch:ResourceTag/environment"
      values   = [var.env]
    }
  }
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = ["*"]
  }
}
