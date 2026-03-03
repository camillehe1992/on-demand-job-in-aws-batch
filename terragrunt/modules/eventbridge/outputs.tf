output "event_rule" {
  value = {
    arn = aws_cloudwatch_event_rule.event_rule.arn
  }
}
