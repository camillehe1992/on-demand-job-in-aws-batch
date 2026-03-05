resource "random_string" "resource_suffix" {
  length  = 3
  special = false
  upper   = false
}

resource "aws_batch_compute_environment" "compute_environment" {
  name = "${local.resource_prefix}-ce-${random_string.resource_suffix.result}"

  compute_resources {
    instance_type = var.instance_types
    instance_role = local.batch_instance_role_profile_arn

    max_vcpus     = var.max_vcpus
    min_vcpus     = var.min_vcpus
    desired_vcpus = var.desired_vcpus

    subnets            = var.subnet_ids
    security_group_ids = var.security_group_ids

    type                = "EC2"
    spot_iam_fleet_role = null # Configure Spot IAM Fleet Role if using Spot Instances
  }

  service_role = local.aws_batch_service_role_arn
  type         = "MANAGED"

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      compute_resources[0].desired_vcpus, # Allow auto scaling
    ]
  }

  tags = var.tags
}
