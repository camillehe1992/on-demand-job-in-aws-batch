terraform {
  backend "s3" {}

  required_version = ">= 1.14.0" # 使用更灵活的版本约束
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # 使用最新稳定版本
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
