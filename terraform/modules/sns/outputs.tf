output "sns_topic" {
  description = "ARN of the SNS topic"
  value = {
    arn = aws_sns_topic.notification_topic.arn
  }
}
