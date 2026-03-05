# Production environment configuration
locals {
  # Environment-specific settings
  env = "prod"

  # Production-specific configuration
  config = {
    # Compute environment settings
    max_vcpus = 8
  }

  # Environment-specific tags
  environment_tags = {
    Environment = local.env
  }
}
