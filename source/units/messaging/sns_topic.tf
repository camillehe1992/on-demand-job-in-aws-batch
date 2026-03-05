
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

# Create an SNS topic to receive job-failed events
module "job_failed_alert_sns_topic" {
  source = "../../modules/sns_topic"

  topic_name                   = "${local.resource_prefix}-job-failed-alert"
  notification_email_addresses = var.notification_email_addresses
  sns_topic_policy             = data.aws_iam_policy_document.sns_topic_policy.json

  tags = var.tags
}
