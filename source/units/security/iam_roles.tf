# IAM Role for AWS Batch Execution
module "batch_execution_role" {
  source = "../../modules/iam_role"

  role_name        = "${local.resource_prefix}-batch-execution-role"
  role_description = "The execution role grants the Amazon ECS container permission to make AWS API calls"
  principals = {
    "Service" = {
      type        = "Service"
      identifiers = ["batch.amazonaws.com"]
    }
  }
  aws_managed_policy_arns = [
    "arn:${local.aws_partition}:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:${local.aws_partition}:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  ]
  user_managed_policies = {
    "secrets-policy" = data.aws_iam_policy_document.role_policy.json
  }
  tags = var.tags
}

module "batch_instance_role" {
  source = "../../modules/iam_role"

  role_name        = "${local.resource_prefix}-batch-instance-role"
  role_description = "The IAM role and instance profile for the container instances to use when they're launched"
  principals = {
    "Service" = {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
  aws_managed_policy_arns = [
    "arn:${local.aws_partition}:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  ]
  has_iam_instance_profile = true
  tags                     = var.tags
}

module "eventbridge_role" {
  source = "../../modules/iam_role"


  role_name        = "${local.resource_prefix}-cw-event-trigger-batch-role"
  role_description = "The IAM role is used by CloudWatch rule to trigger target - AWS Batch"
  principals = {
    "Service" = {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
  user_managed_policies = {
    "submit-batch-job-policy" = data.aws_iam_policy_document.cw_event_role_policy.json
  }
  tags = var.tags
}
