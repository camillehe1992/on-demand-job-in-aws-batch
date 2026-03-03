# EventBridge module for development environment

include "env" {
  path = find_in_parent_folders("env.hcl")
}

terraform {
  source = "../../../terraform/modules/eventbridge"
}

inputs = {
  env      = local.env
  nickname = local.application_name
  tags     = local.tags
  
  # Scheduled job trigger
  rule_name           = "submit-batch-job-rule"
  rule_description    = "Submit a Batch job as scheduled"
  schedule_expression = "cron(0 4 * * ? *)"  # 4 AM UTC daily
  is_enabled          = false
  target_arn                      = dependency.batch.outputs.batch_job_queue.id
  target_id                       = "submitBatchJob"
  role_arn                        = dependency.iam.outputs.cw_event_trigger_batch_role_arn
  batch_target_job_definition_arn = dependency.batch.outputs.batch_job_definition.arn
  job_name                        = "triggered-via-eventbridge"
  rule_input                      = "{}"
  
  # Job failure monitoring
  event_rule_name        = "capture_failed_batch_job_rule"
  event_rule_description = "Register an event rule that captures only job-failed events"
  event_pattern = jsonencode({
    "detail-type" : [
      "Batch Job State Change"
    ],
    "source" : [
      "aws.batch"
    ],
    "detail" : {
      "jobDefinition" : [dependency.batch.outputs.batch_job_definition.arn]
      "status" : [
        "FAILED"
      ]
    }
  })
  event_target_arn = dependency.sns.outputs.sns_topic_arn
  event_target_id  = "sendToSNS"
}

# Dependencies
dependency "iam" {
  config_path = "../iam"
}

dependency "batch" {
  config_path = "../batch"
}

dependency "sns" {
  config_path = "../sns"
}
