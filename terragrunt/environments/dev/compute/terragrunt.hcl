# Batch module for development environment

include "env" {
  path = find_in_parent_folders("env.hcl")
}

terraform {
  source = "../../../terraform/modules/batch"
}

inputs = {
  env      = local.env
  nickname = local.application_name
  tags     = local.tags
  
  # Batch compute environment
  instance_type      = local.config.instance_types
  max_vcpus          = local.config.max_vcpus
  min_vcpus          = local.config.min_vcpus
  desired_vcpus      = local.config.desired_vcpus
  subnet_ids         = local.network_config.private_subnet_ids
  security_group_ids = local.network_config.security_group_ids
  
  # Job definition
  attempt_duration_seconds   = local.config.job_timeout
  retry_strategy_attempts    = local.config.retry_attempts
  parameters                 = {}
  command                    = ["echo", "hello world"]
  job_image_name             = "public.ecr.aws/amazonlinux/amazonlinux:latest"
  resource_requirements_vcpu = "1"
  resource_requirements_mem  = "128"
  volumes                    = []
  mount_points               = []
  environment = {
    LOG_LEVEL = "debug"
  }
  
  # Dependencies
  instance_role_arn  = dependency.iam.outputs.batch_instance_role_arn
  job_role_arn       = dependency.iam.outputs.batch_execution_role_arn
  execution_role_arn = dependency.iam.outputs.batch_execution_role_arn
  secrets = {
    MY_SECRET = dependency.secretsmanager.outputs.secrets.my_secret.arn
  }
}

# Dependencies
dependency "iam" {
  config_path = "../iam"
}

dependency "secretsmanager" {
  config_path = "../secretsmanager"
}
