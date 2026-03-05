output "batch_execution_role_arn" {
  description = "ARN of the Batch execution role"
  value       = module.batch_execution_role.role_arn
}

output "batch_instance_role_arn" {
  description = "ARN of the Batch instance role"
  value       = module.batch_instance_role.role_arn
}

output "eventbridge_role_arn" {
  description = "ARN of the EventBridge role"
  value       = module.eventbridge_role.role_arn
}

output "secrets" {
  description = "Secrets of the Batch job"
  value       = module.secrets.secrets
}
