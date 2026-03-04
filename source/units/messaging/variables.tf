variable "application_name" {
  type        = string
  description = "The name of application. Must be lowercase without special chars"
}

variable "env" {
  type        = string
  description = "The environment of application"
}

variable "tags" {
  type        = map(string)
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
  default     = {}
}

# Scheduled job trigger
variable "schedule_expression" {
  type        = string
  description = "The schedule expression for CW Event rule in UTC. Trigger at 1:00 AM at UTC"
  default     = "cron(0 4 * * ? *)"
}

variable "notification_email_addresses" {
  type        = list(string)
  description = "The list of email address that subscribes the SNS topic to receive notification"
  default     = []

  validation {
    condition = alltrue([
      for email in var.notification_email_addresses : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))
    ])
    error_message = "notification_email_addresses must be a list of valid email addresses"
  }
}

variable "batch_job_definition_arn" {
  type        = string
  description = "The ARN of Batch job definition"
}

variable "batch_job_queue_arn" {
  type        = string
  description = "The ARN of Batch job queue"
}

variable "eventbridge_role_arn" {
  type        = string
  description = "The ARN of IAM role to be used for this target when the rule is triggered"
}
