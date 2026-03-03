locals {
  is_batch_target = var.target_id == "submitBatchJob"
  is_sns_target   = var.target_id == "sendToSNS"
  resource_prefix = "${var.resource_prefix}-${var.rule_name}"
}

resource "aws_cloudwatch_event_rule" "event_rule" {
  name                = local.resource_prefix
  description         = var.rule_description
  schedule_expression = var.schedule_expression
  event_pattern       = var.event_pattern
  state               = var.is_enabled ? "ENABLED" : "DISABLED"

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "event_target" {
  count    = local.is_batch_target ? 1 : 0
  rule     = aws_cloudwatch_event_rule.event_rule.name
  arn      = var.target_arn
  role_arn = var.role_arn
  input    = var.rule_input

  batch_target {
    job_definition = var.batch_target_job_definition_arn
    job_name       = var.job_name
  }
}

resource "aws_cloudwatch_event_target" "job_failed_event_target" {
  count = local.is_sns_target ? 1 : 0
  rule  = aws_cloudwatch_event_rule.event_rule.name
  arn   = var.target_arn

  input_transformer {
    input_paths = {
      jobArn  = "$.detail.jobArn",
      jobName = "$.detail.jobName"
      status  = "$.detail.status",
    }
    input_template = "\"<jobName> [<jobArn>] is in state <status>\""
  }
}
