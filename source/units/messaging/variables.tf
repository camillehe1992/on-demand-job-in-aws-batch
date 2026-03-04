variable "env" {
  type        = string
  description = "The environment of application"
}

variable "application_name" {
  type        = string
  description = "The name of application. Must be lowercase without special chars"
}

variable "tags" {
  type        = map(string)
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
  default     = {}
}

variable "schedule_expression" {
  type        = string
  default     = ""
  description = "The schedule expression for CW Event rule in UTC. Trigger at 1:00 AM at UTC"
}
