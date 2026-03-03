variable "tags" {
  type        = map(string)
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
  default     = {}
}

variable "secret_prefix" {
  type        = string
  description = "The prefix of secret"
}

variable "kms_key_alias" {
  type        = string
  nullable    = true
  description = "The KMS key alias to use for encrypting the secret value. If not specified, the default AWS managed key will be used."
}

variable "secret_specs" {
  type = map(object({
    description   = string
    secret_string = string
  }))
  default = {}
}
