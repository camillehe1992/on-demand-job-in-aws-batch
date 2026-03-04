
output "submit_batch_job_event_rule_arn" {
  description = "ARN of the EventBridge rule that submits a Batch job as scheduled"
  value       = module.submit_batch_job_event.event_rule_arn
}

output "capture_failed_batch_event_rule_arn" {
  description = "ARN of the EventBridge rule that captures only job-failed events"
  value       = module.capture_failed_batch_event.event_rule_arn
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic that receives job-failed events"
  value       = module.job_failed_alert_sns_topic.sns_topic_arn
}
