# Common variables and configuration for all environments

locals {
  # Common tags for all resources
  common_tags = {
    Project    = "on-demand-job-in-aws-batch"
    ManagedBy  = "terragrunt"
    Terraform  = "true"
    CostCenter = "platform"
    Owner      = "platform-team"
  }

  # Application name
  application_name = "helloworld"

  # Default AWS profile (can be overridden per environment)
  aws_profile = null

  # Common network configuration
  network_config = {
    vpc_id             = "vpc-02fd20cf215e9a54b" # Replace with your VPC ID
    private_subnet_ids = ["subnet-01afe14bdcb7e6cb9", "subnet-00057cdf4e7655c62", "subnet-0b257db52c4906a75"]
    public_subnet_ids  = ["subnet-05caf66e740964d47", "subnet-0ac7236fe344b9a9c", "subnet-0a81c8b4c0bf960bb"]
    security_group_ids = ["sg-0579f97438569f812"]
  }
}
