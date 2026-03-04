output "compute_environment_arn" {
  value = aws_batch_compute_environment.compute_environment.arn
}

output "batch_job_queue_arn" {
  value = aws_batch_job_queue.batch_job_queue.arn
}

output "batch_job_definition_arn" {
  value = aws_batch_job_definition.batch_job_definition.arn
}
