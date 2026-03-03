# Common variables and configuration for all environments

locals {
  # Common tags for all resources
  common_tags = {
    Project     = "on-demand-job-in-aws-batch"
    ManagedBy   = "terragrunt"
    Terraform   = "true"
    CostCenter  = "platform"
    Owner       = "platform-team"
  }
  
  # Application name
  application_name = "helloworld"
  
  # Default AWS profile (can be overridden per environment)
  aws_profile = null
  
  # Common network configuration
  network_config = {
    vpc_id             = "vpc-12345678"  # Replace with your VPC ID
    private_subnet_ids = ["subnet-04839c488f31e2829", "subnet-08122d3fc6e3ce9b1"]
    public_subnet_ids  = ["subnet-public1", "subnet-public2"]
    security_group_ids = ["sg-00fe42c9972b4e4af"]
  }
}
