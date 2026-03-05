# General deployment variables
variable "tags" {
  type        = map(string)
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
  default     = {}
}
# Event rule variables
variable "rule_name" {
  type        = string
  description = "The name of EventBridge rule to trigger a submit of job"
}

variable "rule_description" {
  type        = string
  description = "The description of the rule"
  default     = ""
}

variable "role_arn" {
  type        = string
  description = "The ARN of the IAM role to be used for this target when the rule is triggered"
  nullable    = true
  default     = null
}

variable "schedule_expression" {
  type        = string
  description = "The schedule expression for CW Event rule in UTC. Trigger at 1:00 AM at UTC"
  nullable    = true
  default     = null
}

variable "event_pattern" {
  type        = string
  description = "The event pattern that rule should capture. At least one of schedule_expression or event_pattern is required."
  nullable    = true
  default     = null
}

variable "event_bus_name" {
  type        = string
  description = "The name of the event bus to associate with this rule. Default to default"
  nullable    = true
  default     = "default"
}

variable "is_enabled" {
  type        = bool
  description = "If enable the rule. Default to true"
  default     = true
}

# Event target variables
variable "target_arn" {
  type        = string
  description = "The ARN of the target"
}

variable "rule_input" {
  type        = string
  description = "The input of the rule"
  default     = "{}"
}

variable "batch_target_specs" {
  type = object({
    job_definition = string
    job_name       = string
    array_size     = number
    job_attempts   = number
  })
  description = "The specifications for the Batch job to submit"
  nullable    = true
  default     = null
}

variable "input_transformer_specs" {
  type = object({
    input_paths    = map(string)
    input_template = string
  })
  description = "The input transformer specifications for the rule"
  nullable    = true
  default     = null
}
