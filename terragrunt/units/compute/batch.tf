module "batch" {
  source = "./terraform/modules/batch"

  env      = var.env
  nickname = var.nickname
  tags     = var.tags
  # CE & JQ
  instance_type      = var.instance_type
  instance_role_arn  = module.batch_instance_role.iam_role.arn
  max_vcpus          = var.max_vcpus
  min_vcpus          = var.min_vcpus
  desired_vcpus      = var.desired_vcpus
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids
  # JD
  attempt_duration_seconds   = var.attempt_duration_seconds
  retry_strategy_attempts    = var.retry_strategy_attempts
  parameters                 = {}
  command                    = var.command
  job_image_name             = var.job_image_name
  job_role_arn               = module.batch_execution_role.iam_role.arn
  execution_role_arn         = module.batch_execution_role.iam_role.arn
  resource_requirements_vcpu = var.resource_requirements_vcpu
  resource_requirements_mem  = var.resource_requirements_mem
  volumes                    = []
  mount_points               = []
  environment = {
    LOG_LEVEL = var.log_level
  }
  secrets = {
    MY_SECRET = module.secretsmanager_secrets.secrets.my_secret.arn,
  }
}
