# Send email notification with presigned url via SNS topic
resource "aws_sns_topic" "notification_topic" {
  name            = "${var.env}-${var.nickname}-${var.topic_name}"
  delivery_policy = <<EOF
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
  tags            = var.tags
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
