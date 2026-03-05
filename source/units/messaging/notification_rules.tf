module "capture_failed_batch_job_event_rule" {
  source = "../../modules/eventbridge_rule"

  rule_name        = "${local.resource_prefix}-capture-failed-batch-job"
  rule_description = "Captures only job-failed events and notify to DevOps via SNS topic"
  is_enabled       = var.failed_job_notification_enabled
  target_arn       = module.job_failed_alert_sns_topic.sns_topic_arn
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
  input_transformer_specs = {
    input_paths = {
      jobArn  = "$.detail.jobArn",
      jobName = "$.detail.jobName"
      status  = "$.detail.status",
    }
    input_template = "\"<jobName> [<jobArn>] is in state <status>\""
  }
  tags = var.tags
}
