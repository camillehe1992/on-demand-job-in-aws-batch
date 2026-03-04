resource "aws_batch_compute_environment" "compute_environment" {
  name = "${var.env}-${var.application_name}-ce"

  compute_resources {
    instance_type = var.instance_type
    instance_role = local.batch_instance_role_profile_arn

    max_vcpus     = var.max_vcpus
    min_vcpus     = var.min_vcpus
    desired_vcpus = var.desired_vcpus

    subnets            = var.subnet_ids
    security_group_ids = var.security_group_ids

    type                = "EC2"
    spot_iam_fleet_role = null # 如使用Spot实例需要配置

    # 启用详细监控
    # launch_template {
    #   launch_template_name = "${var.env}-${var.nickname}-batch-template"
    #   version              = "$Latest"
    # }
  }

  service_role = local.aws_batch_service_role_arn
  type         = "MANAGED"

  # 生命周期管理
  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      compute_resources[0].desired_vcpus, # 允许自动扩缩容调整
    ]
  }

  tags = var.tags
}

resource "aws_batch_job_queue" "batch_job_queue" {
  name     = "${var.env}-${var.application_name}-jq"
  state    = "ENABLED"
  priority = 1

  tags = var.tags
}
