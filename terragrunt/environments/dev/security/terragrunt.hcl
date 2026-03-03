# IAM module for development environment

include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

include "common" {
  path = find_in_parent_folders("common.hcl")
  expose = true
}

include "env" {
  path = find_in_parent_folders("env.hcl")
  expose = true
}

terraform {
  source = "${get_terragrunt_dir()}/../../../units//security"
}

locals {
  current_region = include.root.locals.current_region
  env = include.env.locals.env
  application_name = include.common.locals.application_name
  tags = merge(include.common.locals.common_tags, include.env.locals.environment_tags)
}

inputs = {
  env      = local.env
  application_name = local.application_name
  tags     = local.tags

  secret_specs = {
    batch-secret = {
      description   = "Secret for Batch"
      secret_string = "BATCH_SECRET"
    }
  }
}
