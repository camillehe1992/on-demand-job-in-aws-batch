# Send email notification with presigned url via SNS topic
resource "aws_sns_topic" "notification_topic" {
  name              = "${var.env}-${var.nickname}-${var.topic_name}"
  kms_master_key_id = aws_kms_key.sns_key.id # 启用服务器端加密
  delivery_policy   = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
  tags              = var.tags
}

# 创建KMS密钥用于SNS加密
resource "aws_kms_key" "sns_key" {
  description             = "KMS key for ${var.env}-${var.nickname} SNS topic encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(var.tags, {
    Name = "${var.env}-${var.nickname}-sns-key"
  })
}

resource "aws_kms_alias" "sns_key_alias" {
  name          = "alias/${var.env}-${var.nickname}-sns"
  target_key_id = aws_kms_key.sns_key.key_id
}

resource "aws_sns_topic_subscription" "trigger_topic_emails" {
  for_each = toset(var.notification_email_addresses)

  topic_arn = aws_sns_topic.notification_topic.arn
  protocol  = "email"
  endpoint  = each.key
}

resource "aws_sns_topic_policy" "allow_publish_policy" {
  arn    = aws_sns_topic.notification_topic.arn
  policy = var.sns_topic_policy
}
