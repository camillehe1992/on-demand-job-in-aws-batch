
# General deployment variables
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

# Unit-specific variables
variable "secret_specs" {
  type = map(object({
    description   = string
    secret_string = string
  }))
  description = "A map of secrets with key-value pairs"
  default     = {}
}
