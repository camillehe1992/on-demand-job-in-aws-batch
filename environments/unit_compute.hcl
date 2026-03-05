# Compute unit configuration - shared across all environments

# Unit-specific inputs for compute resources
inputs = {
  # Batch compute environment
  instance_types = ["c5.large", "c5.xlarge", "c5.2xlarge"]
  min_vcpus      = 0
  desired_vcpus  = 0

  # Job definition
  attempt_duration_seconds   = 3600
  retry_strategy_attempts    = 3
  parameters                 = {}
  command                    = ["echo", "hello world"]
  job_image                  = "public.ecr.aws/amazonlinux/amazonlinux:latest"
  resource_requirements_vcpu = "1"
  resource_requirements_mem  = "128"
}

# Unit-specific locals
locals {
  unit_tags = {
    Unit = "compute"
  }
}
