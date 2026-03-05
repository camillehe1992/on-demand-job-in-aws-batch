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

variable "submit_job_enabled" {
  type        = bool
  description = "Enable submit Batch job event rule"
  default     = true
}

variable "schedule_expression" {
  type        = string
  description = "The schedule expression for CW Event rule in UTC. Trigger at 1:00 AM at UTC"
  default     = "cron(0 4 * * ? *)"
}

variable "eventbridge_role_arn" {
  type        = string
  description = "The ARN of IAM role to be used for this target when the rule is triggered"
  validation {
    condition     = can(regex("^arn:[^:]+:[^:]+:[^:]*:[^:]*:.*$", var.eventbridge_role_arn))
    error_message = "The ARN must be in a valid format: arn:partition:service:region:account:resource"
  }
  nullable = true
}

variable "batch_job_definition_arn" {
  type        = string
  description = "The ARN of Batch job definition"
  validation {
    condition     = can(regex("^arn:[^:]+:[^:]+:[^:]*:[^:]*:.*$", var.batch_job_definition_arn))
    error_message = "The ARN must be in a valid format: arn:partition:service:region:account:resource"
  }
}

variable "batch_job_queue_arn" {
  type        = string
  description = "The ARN of Batch job queue"
  validation {
    condition     = can(regex("^arn:[^:]+:[^:]+:[^:]*:[^:]*:.*$", var.batch_job_queue_arn))
    error_message = "The ARN must be in a valid format: arn:partition:service:region:account:resource"
  }
}

variable "failed_job_notification_enabled" {
  type        = bool
  description = "Enable job failed notification SNS Topic email subscription"
  default     = false
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
