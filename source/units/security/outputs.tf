output "batch_execution_role_arn" {
  value = module.batch_execution_role.role_arn
}

output "batch_instance_role_arn" {
  value = module.batch_instance_role.role_arn
}

output "eventbridge_role_arn" {
  value = module.eventbridge_role.role_arn
}

output "secrets" {
  value = module.secrets.secrets
}
