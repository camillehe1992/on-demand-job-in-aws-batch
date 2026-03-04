resource "aws_batch_job_queue" "batch_job_queue" {
  name     = "${local.resource_prefix}-jq"
  state    = "ENABLED"
  priority = 1

  compute_environment_order {
    order               = 1
    compute_environment = aws_batch_compute_environment.compute_environment.arn
  }

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
