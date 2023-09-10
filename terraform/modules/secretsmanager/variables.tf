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

variable "secret_specs" {
  type = map(object({
    description   = string
    secret_string = string
  }))
}
