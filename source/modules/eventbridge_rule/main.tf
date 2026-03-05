resource "aws_cloudwatch_event_rule" "event_rule" {
  name                = var.rule_name
  description         = var.rule_description
  schedule_expression = var.schedule_expression
  event_pattern       = var.event_pattern
  event_bus_name      = var.event_bus_name
  state               = var.is_enabled ? "ENABLED" : "DISABLED"

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "event_target" {
  rule     = aws_cloudwatch_event_rule.event_rule.name
  role_arn = var.role_arn
  arn      = var.target_arn
  input    = var.input_transformer_specs == null ? var.rule_input : null

  dynamic "batch_target" {
    for_each = var.batch_target_specs != null ? [1] : []
    content {
      job_definition = var.batch_target_specs.job_definition
      job_name       = var.batch_target_specs.job_name
      array_size     = var.batch_target_specs.array_size
      job_attempts   = var.batch_target_specs.job_attempts
    }
  }

  dynamic "input_transformer" {
    for_each = var.input_transformer_specs != null ? [1] : []
    content {
      input_paths    = var.input_transformer_specs.input_paths
      input_template = var.input_transformer_specs.input_template
    }
  }
}
