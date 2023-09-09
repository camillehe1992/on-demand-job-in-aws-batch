# General deployment variables
variable "env" {
  type        = string
  description = "The environment of application"
}

variable "nickname" {
  type        = string
  description = "The nickname of application. Must be lowercase without special chars"
}

variable "tags" {
  type        = map(string)
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
}

# Event rule

variable "rule_name" {
  type        = string
  description = "The name of EventBridge rule to trigger a submit of job"
}

variable "rule_description" {
  type        = string
  description = "The description of the rule"
}

variable "schedule_expression" {
  type        = string
  default     = "cron(0 1 * * ? *)"
  description = "The schedule expression for CW Event rule in UTC. Trigger at 1:00 AM at UTC"
}

variable "is_enabled" {
  type        = bool
  default     = true
  description = "If enable the rule"
}

variable "target_arn" {
  type        = string
  description = "The ARN of the target"
}

variable "role_arn" {
  type        = string
  description = "The ARN of the IAM role to be used for this target when the rule is triggered"
}

variable "rule_input" {
  type        = string
  default     = "{}"
  description = "The input of the rule"
}

variable "batch_target_job_definition_arn" {
  type        = string
  description = "The ARN or name of the job definition to use if the event target is an AWS Batch job"
}
variable "job_name" {
  type        = string
  description = "The name of Batch job submitted"
}


