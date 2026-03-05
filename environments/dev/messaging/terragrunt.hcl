# EventBridge module for development environment

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
}

# Unit-specific inputs
inputs = {
  application_name = local.application_name
  env      = local.env
  tags     = local.tags
  
  # EventBridge
  notification_email_addresses = ["camille.he@outlook.com"]

  # Dependencies
  batch_job_queue_arn = dependency.compute.outputs.batch_job_queue_arn
  eventbridge_role_arn = dependency.security.outputs.eventbridge_role_arn
  batch_job_definition_arn = dependency.compute.outputs.batch_job_definition_arn
}

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

# Dependencies
dependency "security" {
  config_path = "../security"
}

dependency "compute" {
  config_path = "../compute"
}
