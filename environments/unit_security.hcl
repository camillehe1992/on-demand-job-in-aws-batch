# Security unit configuration - shared across all environments

# Unit-specific inputs for security resources
inputs = {
  secret_specs = {}
}

# Unit-specific locals
locals {
  unit_tags = {
    Unit = "security"
  }
}
