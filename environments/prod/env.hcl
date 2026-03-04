# Production environment configuration

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "common" {
  path = find_in_parent_folders("common.hcl")
}

locals {
  # Environment-specific settings
  env = "prod"
  
  # Production-specific configuration
  config = {
    # Compute environment settings
    instance_types = ["c5.large", "c5.xlarge"]
    max_vcpus      = 64
    min_vcpus      = 0
    desired_vcpus  = 4  # Keep capacity for immediate response
    
    # Job settings
    retry_attempts = 3
    job_timeout    = 300
    
    # Cost optimization
    spot_instances = true
    enable_spot    = true
    spot_percentage = 70
    multi_az        = true
    
    # Monitoring (most aggressive in prod)
    enable_detailed_monitoring = true
    alarm_threshold           = 5  # 5% failure rate
    
    # Backup and retention
    backup_retention = 30
    
    # Email notifications
    notification_emails = ["prod-team@example.com", "platform-team@example.com", "oncall@example.com"]
  }
  
  # Environment-specific tags
  environment_tags = {
    Environment = local.env
    CostCenter   = "prod-001"
  }
  
  # Merge common and environment tags
  tags = merge(local.common_tags, local.environment_tags)
}
