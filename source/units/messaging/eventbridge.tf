
locals {
  resource_prefix = "${var.env}-${var.application_name}"
}

module "submit_batch_job_event" {
  source = "../../modules/eventbridge"

  # rule
  rule_name           = "${local.resource_prefix}-submit-batch-job-rule"
  rule_description    = "Submit a Batch job as scheduled"
  schedule_expression = var.schedule_expression
  is_enabled          = true
  # rule target
  target_arn                      = var.batch_job_queue_arn
  target_id                       = "submitBatchJob"
  role_arn                        = var.eventbridge_role_arn
  batch_target_job_definition_arn = var.batch_job_definition_arn
  job_name                        = "triggered-via-eventbridge"

  tags = var.tags
}

module "capture_failed_batch_event" {
  source = "../../modules/eventbridge"

  # rule
  rule_name        = "${local.resource_prefix}-capture-failed-batch-job-rule"
  rule_description = "Register an event rule that captures only job-failed events"
  event_pattern = jsonencode({
    "detail-type" : [
      "Batch Job State Change"
    ],
    "source" : [
      "aws.batch"
    ],
    "detail" : {
      "jobDefinition" : [var.batch_job_definition_arn]
      "status" : [
        "FAILED"
      ]
    }
  })
  is_enabled = true
  # rule target
  target_arn = module.job_failed_alert_sns_topic.sns_topic_arn
  target_id  = "sendToSNS"
  role_arn   = var.eventbridge_role_arn

  tags = var.tags
}
