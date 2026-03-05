# Local configuration that combines all includes
locals {
  application_name = include.common.locals.application_name
  env = include.env.locals.env
  tags = merge(
    include.common.locals.common_tags,
    include.env.locals.environment_tags, 
    include.security_unit.locals.unit_tags
  )
}

# Unit-specific inputs
inputs = merge(
  include.security_unit.inputs,
  {
    env      = local.env
    application_name = local.application_name
    tags     = local.tags
  }
)

# Include root/ common/ and env/ modules
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

include "security_unit" {
  path = find_in_parent_folders("unit_security.hcl")
  expose = true
}
