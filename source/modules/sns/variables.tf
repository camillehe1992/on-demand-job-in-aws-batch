variable "env" {
  type        = string
  description = "The environment of application"
}

variable "nickname" {
  type        = string
  description = "The nickname of application"
}

variable "tags" {
  type        = map(string)
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
}

variable "topic_name" {
  type        = string
  description = "The name of the topic"
}

variable "notification_email_addresses" {
  type        = list(string)
  description = "The list of email address that subscribes the SNS topic to receive notification"
}

variable "sns_topic_policy" {
  type        = string
  description = "The SNS topic policy for allowing particular actions on topic"
}
