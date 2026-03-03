
output "submit_batch_job_event_rule_arn" {
  value = module.submit_batch_job_event.event_rule.arn
}

output "capture_failed_batch_event_rule_arn" {
  value = module.capture_failed_batch_event.event_rule.arn
}

output "sns_topic_arn" {
  value = module.job_failed_alert_sns_topic.sns_topic.arn
}
