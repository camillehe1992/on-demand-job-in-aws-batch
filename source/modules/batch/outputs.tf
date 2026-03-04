output "batch_compute_environment" {
  value = {
    arn = aws_batch_compute_environment.compute_environment.arn
  }
}

output "batch_job_queue" {
  value = {
    arn = aws_batch_job_queue.batch_job_queue.arn
    id  = aws_batch_job_queue.batch_job_queue.id
  }
}

output "batch_job_definition" {
  value = {
    arn      = aws_batch_job_definition.batch_job_definition.arn
    revision = aws_batch_job_definition.batch_job_definition.revision
  }
}

