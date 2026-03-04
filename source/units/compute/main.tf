resource "aws_batch_compute_environment" "compute_environment" {
  name = "${local.resource_prefix}-ce"

  compute_resources {
    instance_type = var.instance_type
    instance_role = local.batch_instance_role_profile_arn

    max_vcpus     = var.max_vcpus
    min_vcpus     = var.min_vcpus
    desired_vcpus = var.desired_vcpus

    subnets            = data.aws_subnets.public_subnets
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

resource "aws_batch_job_queue" "batch_job_queue" {
  name     = "${local.resource_prefix}-jq"
  state    = "ENABLED"
  priority = 1

  tags = var.tags
}

resource "aws_batch_job_definition" "batch_job_definition" {
  name = "${local.resource_prefix}-jd"
  type = "container"

  timeout {
    attempt_duration_seconds = var.attempt_duration_seconds
  }

  retry_strategy {
    attempts = var.retry_strategy_attempts
    evaluate_on_exit {
      action           = "RETRY"
      on_exit_code     = "*"
      on_reason        = "*"
      on_status_reason = "*"
    }
  }

  parameters = var.parameters

  container_properties = jsonencode({
    command          = var.command
    image            = var.job_image
    jobRoleArn       = var.job_role_arn
    executionRoleArn = var.execution_role_arn

    resourceRequirements = [
      {
        type  = "VCPU"
        value = var.resource_requirements_vcpu
      },
      {
        type  = "MEMORY"
        value = var.resource_requirements_mem
      }
    ]

    volumes     = var.volumes
    mountPoints = var.mount_points

    environment = var.environment
    secrets     = var.secrets

    logConfiguration = {
      logDriver     = "awslogs",
      options       = {},
      secretOptions = []
    }
  })

  tags = var.tags
}
