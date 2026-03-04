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

locals {
  unit_tags = {
    Unit = basename(get_terragrunt_dir())
  }
  application_name = include.common.locals.application_name
  env = include.env.locals.env
  tags = merge(
    include.common.locals.common_tags,
    include.env.locals.environment_tags, 
    local.unit_tags)
}

inputs = {
  application_name = local.application_name
  env      = local.env
  tags     = local.tags

  secret_specs = {
    batch-secret = {
      description   = "Secret for Batch"
      secret_string = "BATCH_SECRET"
    }
  }
}
