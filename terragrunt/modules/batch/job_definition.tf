resource "aws_batch_job_definition" "batch_job_definition" {
  name = "${var.env}-${var.nickname}-jd"
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
    image            = var.job_image_name
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

    environment = local.environment
    secrets     = local.secrets

    logConfiguration = {
      logDriver     = var.log_driver,
      options       = {},
      secretOptions = []
    }
  })

  tags = var.tags
}
