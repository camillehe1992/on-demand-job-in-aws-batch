# Development environment configuration
# include "root" {
#   path = find_in_parent_folders("root.hcl")
# }

# include "common" {
#   path = find_in_parent_folders("common.hcl")
# }

locals {
  # Environment-specific settings
  env = "dev"
  
  # Development-specific configuration
  config = {
    # Compute environment settings
    instance_types = ["c4.large"]
    max_vcpus      = 8
    min_vcpus      = 0
    desired_vcpus  = 0
    
    # Job settings
    retry_attempts = 1
    job_timeout    = 60
    
    # Cost optimization (dev is most aggressive)
    spot_instances = false
    enable_spot    = false
    
    # Monitoring (less aggressive in dev)
    enable_detailed_monitoring = false
    alarm_threshold           = 20  # 20% failure rate
    
    # Backup and retention
    backup_retention = 7
    
    # Email notifications
    notification_emails = ["dev-team@example.com"]
  }
  
  # Environment-specific tags
  environment_tags = {
    Environment = local.env
  }
  
  # Merge common and environment tags
  # tags = merge(local.common_tags, local.environment_tags)
}
