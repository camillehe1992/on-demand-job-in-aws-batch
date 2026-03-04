variable "secret_prefix" {
  description = "The prefix of secret"
  type        = string
  default     = ""
}

variable "kms_key_id" {
  description = "The KMS key id or ARN to use for encrypting the secret value. If not specified, the default AWS managed key will be used."
  type        = string
  nullable    = true
  default     = null
}

variable "secret_specs" {
  description = "A map of secret specs. Each key is the secret name, and each value is an object with description and secret_string."
  type = map(object({
    description   = string
    secret_string = string
  }))
  default = {}
}

variable "recovery_window_in_days" {
  description = "The number of days to wait before recovery of the secret. Default is 7 days."
  type        = number
  default     = 7
}

variable "tags" {
  description = "The key value pairs we want to apply as tags to the resources contained in this module"
  type        = map(string)
  default     = {}
}
