
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

# CE & JQ
variable "instance_type" {
  type        = list(string)
  description = "A list of instance type that launched in batch compute environment"
}

variable "instance_role_arn" {
  type        = string
  description = "The Amazon ECS instance role ARN applied to Amazon EC2 instances in a compute environment."
}

variable "max_vcpus" {
  type        = number
  default     = 16
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
  description = "The number of vCPUs that your compute environment launches with."
}
variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ids that Batch job runs in"
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security Group ids that Batch job runs in"
}

# JD
variable "attempt_duration_seconds" {
  type        = number
  description = "The time duration in seconds after which AWS Batch terminates your jobs if they have not finished. The minimum value for the timeout is 60 seconds."
}

variable "retry_strategy_attempts" {
  type        = number
  description = "The number of times to move a job to the RUNNABLE status. You may specify between 1 and 10 attempts."
}

variable "parameters" {
  type        = map(string)
  description = "The parameters that defined in command"
}

variable "command" {
  type        = list(string)
  description = "The command that's passed to the container."
}

variable "job_image_name" {
  type        = string
  description = "The repository name of job image"
}

variable "job_role_arn" {
  type        = string
  description = "The ARN of the IAM role that the container can assume for AWS permissions."
}

variable "execution_role_arn" {
  type        = string
  description = "The ARN of the execution role that AWS Batch can assume."
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

variable "volumes" {
  type        = list(object({}))
  description = "A list of data volumes used in a job."
}

variable "mount_points" {
  type        = list(object({}))
  description = "The mount points for data volumes in your container. "
}

variable "environment" {
  type        = map(string)
  description = "The environment variables to pass to a container."
}

variable "secrets" {
  type        = map(string)
  description = "TThe secrets for the container."
}

variable "log_driver" {
  type        = string
  default     = "awslogs"
  description = "The log driver of Batch job"
}
