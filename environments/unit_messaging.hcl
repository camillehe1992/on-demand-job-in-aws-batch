# Messaging unit configuration - shared across all environments

# Unit-specific inputs for messaging resources
inputs = {
  # Email notifications
  notification_email_addresses = ["camille.he@outlook.com"]
}

# Unit-specific locals
locals {
  unit_tags = {
    Unit = "messaging"
  }
}
