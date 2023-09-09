resource "aws_batch_compute_environment" "compute_environment" {
  compute_environment_name = "${var.env}-${var.nickname}-ce"

  compute_resources {
    instance_type = var.instance_type
    instance_role = local.batch_instance_role_profile_arn

    max_vcpus     = var.max_vcpus
    min_vcpus     = var.min_vcpus
    desired_vcpus = var.desired_vcpus

    subnets            = var.subnet_ids
    security_group_ids = var.security_group_ids

    type = "EC2"
  }

  service_role = local.aws_batch_service_role_arn
  type         = "MANAGED"

  tags = var.tags
}

resource "aws_batch_job_queue" "batch_job_queue" {
  name     = "${var.env}-${var.nickname}-jq"
  state    = "ENABLED"
  priority = 1
  compute_environments = [
    aws_batch_compute_environment.compute_environment.arn
  ]

  tags = var.tags
}
