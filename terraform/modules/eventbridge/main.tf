resource "aws_cloudwatch_event_rule" "event_rule" {
  name                = "${var.env}-${var.nickname}-${var.rule_name}"
  description         = var.rule_description
  schedule_expression = var.schedule_expression
  is_enabled          = var.is_enabled

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "event_target" {
  rule     = aws_cloudwatch_event_rule.event_rule.name
  arn      = var.target_arn
  role_arn = var.role_arn
  input    = var.rule_input

  batch_target {
    job_definition = var.batch_target_job_definition_arn
    job_name       = var.job_name
  }
}
