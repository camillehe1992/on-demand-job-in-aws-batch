
locals {
  resource_prefix = "${var.env}-${var.application_name}"
}

module "submit_batch_job_event_rule" {
  source = "../../modules/eventbridge_rule"

  rule_name           = "${local.resource_prefix}-submit-batch-job"
  rule_description    = "Submit a Batch job as scheduled"
  role_arn            = var.eventbridge_role_arn
  schedule_expression = var.schedule_expression
  is_enabled          = var.submit_job_enabled
  target_arn          = var.batch_job_queue_arn
  batch_target_specs = {
    job_definition = var.batch_job_definition_arn
    job_name       = "triggered-via-eventbridge"
    array_size     = null
    job_attempts   = 3
  }
  tags = var.tags
}
