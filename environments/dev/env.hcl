# Development environment configuration
locals {
  # Environment-specific settings
  env = "dev"
  
  # Development-specific configuration
  config = {
    # Compute environment settings
    max_vcpus      = 4
  }
  
  # Environment-specific tags
  environment_tags = {
    Environment = local.env
  }
}
