# Local configuration that combines all includes
locals {
  application_name = include.common.locals.application_name
  env = include.env.locals.env
  tags = merge(
    include.common.locals.common_tags,
    include.env.locals.environment_tags, 
    include.unit_compute.locals.unit_tags
  )
  
  network_config = include.common.locals.network_config
  config = include.env.locals.config
}

# Unit-specific inputs
inputs = merge(
  include.unit_compute.inputs,
  {
    application_name = local.application_name
    env      = local.env
    tags     = local.tags
    
    # Network configuration from common
    vpc_id             = local.network_config.vpc_id
    subnet_ids         = local.network_config.private_subnet_ids
    security_group_ids = local.network_config.security_group_ids
    
    # Environment-specific configuration
    instance_types     = local.config.instance_types
    max_vcpus          = local.config.max_vcpus
    min_vcpus          = local.config.min_vcpus
    desired_vcpus      = local.config.desired_vcpus
    attempt_duration_seconds   = local.config.job_timeout
    retry_strategy_attempts    = local.config.retry_attempts
    
    # Dependencies
    batch_instance_role_arn  = dependency.security.outputs.batch_instance_role_arn
    job_role_arn       = dependency.security.outputs.batch_execution_role_arn
    job_execution_role_arn = dependency.security.outputs.batch_execution_role_arn
  }
)

# Include root/ common/ and env/ modules
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

include "unit_compute" {
  path = find_in_parent_folders("unit_compute.hcl")
  expose = true
}

# Dependencies
dependency "security" {
  config_path = "../security"
}
