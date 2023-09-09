
# General Deployment Variables
variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "aws_profile" {
  type        = string
  description = "AWS profile which is used for the deployment"
}

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

# SecretManager Secrets
# SECRETS ARE INJECTED AS TF_VAR_XXX. NEVER EVER SET A VALUE FOR SECRET HERE
variable "my_secret" {
  type        = string
  description = "The secret"
}

# Batch Variables
variable "instance_type" {
  type        = list(string)
  description = "A list of instance type that launched in batch compute environment"
}

variable "max_vcpus" {
  type        = number
  default     = 8
  description = "The max vCPU that the compute environment maintains"
}

variable "min_vcpus" {
  type        = number
  default     = 0
  description = "The min vCPU that the compute environment maintains"
}

variable "desired_vcpus" {
  type        = number
  default     = 0
  description = "The number of reserved vCPUs that your compute environment launches with."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ids that Batch job runs in"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security Group ids that Batch job runs in"
}

variable "attempt_duration_seconds" {
  type        = number
  default     = 60
  description = "The time duration in seconds after which AWS Batch terminates your jobs if they have not finished. The minimum value for the timeout is 60 seconds."
}

variable "retry_strategy_attempts" {
  type        = number
  default     = 0
  description = "The number of times to move a job to the RUNNABLE status. You may specify between 1 and 10 attempts."
}

variable "command" {
  type        = list(string)
  description = "The command for batch job"
}
variable "job_image_name" {
  type        = string
  description = "The repository name of job image"
}

variable "resource_requirements_vcpu" {
  type        = string
  default     = "1"
  description = "The number of vCPUs reserved for the container. Each vCPU is equivalent to 1,024 CPU shares"
}

variable "resource_requirements_mem" {
  type        = string
  default     = "128"
  description = "The memory hard limit (in MiB) present to the container."
}

variable "log_level" {
  type        = string
  description = "The log level of the job container"
}

# CloudWatch Event(EventBridge) Variables
variable "schedule_expression" {
  type        = string
  description = "The scheduled CRON expression for CloudWatch Event"
}

variable "notification_email_addresses" {
  type        = list(string)
  description = "The list of email address that subscribes the SNS topic to receive notification"
}
