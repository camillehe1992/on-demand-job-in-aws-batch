# Staging environment configuration
locals {
  # Environment-specific settings
  env = "staging"

  # Staging-specific configuration
  config = {
    # Compute environment settings
    max_vcpus = 8
  }

  # Environment-specific tags
  environment_tags = {
    Environment = local.env
  }
}
