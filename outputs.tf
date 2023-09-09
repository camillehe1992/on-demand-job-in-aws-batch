output "batch_execution_role_arn" {
  value = module.batch_execution_role.iam_role.arn
}

output "batch_instance_role_arn" {
  value = module.batch_instance_role.iam_role.arn
}

output "cw_event_trigger_batch_role_arn" {
  value = module.cw_event_trigger_batch_role.iam_role.arn
}

output "secrets" {
  value = module.secretsmanager_secrets.secrets
}

output "batch_job_queue_arn" {
  value = module.batch.batch_job_queue.arn
}

output "batch_job_definition_arn" {
  value = module.batch.batch_job_definition.arn
}

output "submit_batch_job_event_rule_arn" {
  value = module.submit_batch_job_rule.submit_batch_job_event_rule.arn
}

output "sns_topic_arn" {
  value = module.job_failed_alert_sns_topic.sns_topic.arn
}
