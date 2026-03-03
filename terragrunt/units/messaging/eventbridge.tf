
module "submit_batch_job_event" {
  source = "../../modules/eventbridge"
  tags   = var.tags

  resource_prefix = "submit-batch-job"

  # rule
  rule_name           = "submit-batch-job-rule"
  rule_description    = "Submit a Batch job as scheduled"
  schedule_expression = var.schedule_expression
  is_enabled          = false
  # rule target
  target_arn                      = module.batch.batch_job_queue.id
  target_id                       = "submitBatchJob"
  role_arn                        = module.cw_event_trigger_batch_role.iam_role.arn
  batch_target_job_definition_arn = module.batch.batch_job_definition.arn
  job_name                        = "triggered-via-eventbridge"
}

module "capture_failed_batch_event" {
  source = "./terraform/modules/eventbridge"

  env      = var.env
  nickname = var.nickname
  tags     = var.tags

  # rule
  rule_name        = "capture_failed_batch_job_rule"
  rule_description = "Register an event rule that captures only job-failed events"
  event_pattern = jsonencode({
    "detail-type" : [
      "Batch Job State Change"
    ],
    "source" : [
      "aws.batch"
    ],
    "detail" : {
      "jobDefinition" : [module.batch.batch_job_definition.arn]
      "status" : [
        "FAILED"
      ]
    }
  })
  is_enabled = true
  # rule target
  target_arn = module.job_failed_alert_sns_topic.sns_topic.arn
  target_id  = "sendToSNS"
  role_arn   = module.cw_event_trigger_batch_role.iam_role.arn
}
