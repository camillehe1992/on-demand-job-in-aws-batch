module "job_failed_alert_sns_topic" {
  source   = "./terraform/modules/sns"
  env      = var.env
  nickname = var.nickname
  tags     = var.tags

  topic_name                   = "job-failed-alert"
  notification_email_addresses = var.notification_email_addresses

  sns_topic_policy = data.aws_iam_policy_document.sns_topic_policy.json
}
