# Root Terragrunt configuration

locals {
  # Get environment from directory structure
  environment = basename(dirname(get_terragrunt_dir()))

  repository_name = "on-demand-job-in-aws-batch"
  
  # Account mapping for different environments
  account_ids = {
    dev      = "824709318323"      # Your dev account
    staging  = "824709318323"      # Replace with staging account
    prod     = "824709318323"       # Replace with prod account
  }
  
  # Region configuration
  regions = {
    dev      = "ap-southeast-1"
    staging  = "ap-southeast-1" 
    prod     = "ap-southeast-1"
  }
  
  # Get current account and region
  current_account_id = local.account_ids[local.environment]
  current_region     = local.regions[local.environment]
}

# terraform {
#   source = "${get_terragrunt_dir()}/../../../units/${basename(get_original_terragrunt_dir())}"
# }

# Generate provider configuration
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  
  contents = <<EOF
terraform {
  required_version = ">= 1.14.0"

  backend "s3" {}
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "${local.current_region}"
  
  default_tags {
    tags = {
      Environment = "${local.environment}"
      ManagedBy   = "terragrunt"
      Terraform   = "true"
    }
  }
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}
EOF
}

# Remote state configuration
remote_state {
  backend = "s3"
  config = {
    bucket         = "terraform-state-${local.current_account_id}-${local.current_region}"
    key            = "${local.repository_name}/${path_relative_to_include()}/terraform.tfstate"
    region         = local.current_region
    encrypt        = true
    use_lockfile = true
  }
}
