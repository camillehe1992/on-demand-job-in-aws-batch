
output "batch_job_queue_arn" {
  value = module.batch.batch_job_queue.arn
}

output "batch_job_definition_arn" {
  value = module.batch.batch_job_definition.arn
}
