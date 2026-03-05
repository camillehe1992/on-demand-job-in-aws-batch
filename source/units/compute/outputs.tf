output "compute_environment_arn" {
  description = "ARN of the Batch compute environment"
  value       = aws_batch_compute_environment.compute_environment.arn
}

output "batch_job_queue_arn" {
  description = "ARN of the Batch job queue"
  value       = aws_batch_job_queue.batch_job_queue.arn
}

output "batch_job_definition_arn" {
  description = "ARN of the Batch job definition"
  value       = aws_batch_job_definition.batch_job_definition.arn
}
