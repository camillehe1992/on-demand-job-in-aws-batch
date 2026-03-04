# Batch module for development environment

include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

include "common" {
  path = find_in_parent_folders("common.hcl")
  expose = true
}

include "env" {
  path = find_in_parent_folders("env.hcl")
  expose = true
}

locals {
  unit_tags = {
    Unit = basename(get_terragrunt_dir())
  }
  application_name = include.common.locals.application_name
  env = include.env.locals.env
  tags = merge(
    include.common.locals.common_tags,
    include.env.locals.environment_tags, 
    local.unit_tags)
  
  network_config = include.common.locals.network_config
  config = include.env.locals.config
}

inputs = {
  application_name = local.application_name
  env      = local.env
  tags     = local.tags
  
  # Batch compute environment
  instance_types      = local.config.instance_types
  max_vcpus          = local.config.max_vcpus
  min_vcpus          = local.config.min_vcpus
  desired_vcpus      = local.config.desired_vcpus
  vpc_id             = local.network_config.vpc_id
  security_group_ids = local.network_config.security_group_ids
  
  # Job definition
  attempt_duration_seconds   = local.config.job_timeout
  retry_strategy_attempts    = local.config.retry_attempts
  parameters                 = {}
  command                    = ["echo", "hello world"]
  job_image                  = "public.ecr.aws/amazonlinux/amazonlinux:latest"
  resource_requirements_vcpu = "1"
  resource_requirements_mem  = "128"
  environment = []
  
  # Dependencies
  instance_role_arn  = dependency.security.outputs.batch_instance_role_arn
  job_role_arn       = dependency.security.outputs.batch_execution_role_arn
  execution_role_arn = dependency.security.outputs.batch_execution_role_arn
  secrets = []
}

# Dependencies
dependency "security" {
  config_path = "../security"
}
