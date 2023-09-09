resource "aws_cloudwatch_event_rule" "event_rule" {
  name                = "${var.env}-${var.nickname}-${var.rule_name}"
  description         = var.rule_description
  schedule_expression = var.schedule_expression
  event_pattern       = var.event_pattern

  is_enabled = var.is_enabled

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "event_target" {
  count    = var.target_id == "submitBatchJob" ? 1 : 0
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
  count = var.target_id == "sendToSNS" ? 1 : 0
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
