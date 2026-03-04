# Staging environment configuration

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "common" {
  path = find_in_parent_folders("common.hcl")
}

locals {
  # Environment-specific settings
  env = "staging"
  
  # Staging-specific configuration
  config = {
    # Compute environment settings
    instance_types = ["c4.large", "c4.xlarge"]
    max_vcpus      = 16
    min_vcpus      = 0
    desired_vcpus  = 2  # Keep some capacity warm
    
    # Job settings
    retry_attempts = 2
    job_timeout    = 120
    
    # Cost optimization
    spot_instances = true
    enable_spot    = true
    spot_percentage = 50
    
    # Monitoring
    enable_detailed_monitoring = true
    alarm_threshold           = 10  # 10% failure rate
    
    # Backup and retention
    backup_retention = 14
    
    # Email notifications
    notification_emails = ["staging-team@example.com", "platform-team@example.com"]
  }
  
  # Environment-specific tags
  environment_tags = {
    Environment = local.env
    CostCenter   = "staging-001"
  }
  
  # Merge common and environment tags
  tags = merge(local.common_tags, local.environment_tags)
}
