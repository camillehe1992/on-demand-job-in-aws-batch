# Local configuration that combines all includes
locals {
  application_name = include.common.locals.application_name
  env              = include.env.locals.env
  tags = merge(
    include.common.locals.common_tags,
    include.env.locals.environment_tags,
    include.unit_messaging.locals.unit_tags
  )
}

# Unit-specific inputs
inputs = merge(
  include.unit_messaging.inputs,
  {
    application_name = local.application_name
    env              = local.env
    tags             = local.tags

    # Submit Batch job event rule
    submit_job_enabled  = true
    schedule_expression = "cron(0 4 * * ? *)"
    # Dependencies
    eventbridge_role_arn     = dependency.security.outputs.eventbridge_role_arn
    batch_job_definition_arn = dependency.compute.outputs.batch_job_definition_arn
    batch_job_queue_arn      = dependency.compute.outputs.batch_job_queue_arn

    # Job failed notification SNS Topic email subscription list
    failed_job_notification_enabled = true
  }
)

# Include root/ common/ and env/ modules
include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

include "common" {
  path   = find_in_parent_folders("common.hcl")
  expose = true
}

include "env" {
  path   = find_in_parent_folders("env.hcl")
  expose = true
}

include "unit_messaging" {
  path   = find_in_parent_folders("unit_messaging.hcl")
  expose = true
}

# Dependencies
dependency "security" {
  config_path = "../security"

  mock_outputs = {
    eventbridge_role_arn = "arn:aws:iam::123456789012:role/eventbridge-role"
  }
}

dependency "compute" {
  config_path = "../compute"

  mock_outputs = {
    batch_job_definition_arn = "arn:aws:batch:us-east-1:123456789012:job-definition/batch-job-definition:1"
    batch_job_queue_arn      = "arn:aws:batch:us-east-1:123456789012:job-queue/batch-job-queue"
  }
}
