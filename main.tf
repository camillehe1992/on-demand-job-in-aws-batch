module "batch_execution_role" {
  source = "./terraform/modules/iam"

  env      = var.env
  nickname = var.nickname
  tags     = var.tags

  role_name                   = "batch-execution-role"
  role_description            = "The execution role grants the Amazon ECS container permission to make AWS API calls"
  assume_role_policy_document = data.aws_iam_policy_document.ecs_tasks_assume_role_policy.json
  aws_managed_policy_arns = [
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  ]
  customized_policies = {
    secrets-policy = data.aws_iam_policy_document.role_policy.json
  }
  has_iam_instance_profile = false
}

module "batch_instance_role" {
  source = "./terraform/modules/iam"

  env      = var.env
  nickname = var.nickname
  tags     = var.tags

  role_name                   = "batch-instance-role"
  role_description            = "The IAM role and instance profile for the container instances to use when they're launched"
  assume_role_policy_document = data.aws_iam_policy_document.batch_instance_assume_role_policy.json
  aws_managed_policy_arns = [
    "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  ]
  customized_policies      = {}
  has_iam_instance_profile = true
}

module "cw_event_trigger_batch_role" {
  source = "./terraform/modules/iam"

  env      = var.env
  nickname = var.nickname
  tags     = var.tags

  role_name                   = "cw-event-trigger-batch-role"
  role_description            = "The IAM role is used by CloudWatch rule to trigger target - AWS Batch"
  assume_role_policy_document = data.aws_iam_policy_document.events_assume_role_policy.json
  aws_managed_policy_arns     = []
  customized_policies = {
    submit-batch-job-policy = data.aws_iam_policy_document.cw_event_role_policy.json
  }
  has_iam_instance_profile = false
}

module "secretsmanager_secrets" {
  source = "./terraform/modules/secretsmanager_secrets"

  env      = var.env
  nickname = var.nickname
  tags     = var.tags

  secret_specs = {
    my_secret = {
      description   = "A sample secure token that is used in the container, e.g password"
      secret_string = var.my_secret
    }
  }
}

module "batch" {
  source = "./terraform/modules/batch"

  env      = var.env
  nickname = var.nickname
  tags     = var.tags
  # CE & JQ
  instance_type      = var.instance_type
  instance_role_arn  = module.batch_instance_role.iam_role.arn
  max_vcpus          = var.max_vcpus
  min_vcpus          = var.min_vcpus
  desired_vcpus      = var.desired_vcpus
  subnet_ids         = var.subnet_ids
  security_group_ids = var.security_group_ids
  # JD
  attempt_duration_seconds   = var.attempt_duration_seconds
  retry_strategy_attempts    = var.retry_strategy_attempts
  parameters                 = {}
  command                    = var.command
  job_image_name             = var.job_image_name
  job_role_arn               = module.batch_execution_role.iam_role.arn
  execution_role_arn         = module.batch_execution_role.iam_role.arn
  resource_requirements_vcpu = var.resource_requirements_vcpu
  resource_requirements_mem  = var.resource_requirements_mem
  volumes                    = []
  mount_points               = []
  environment = {
    LOG_LEVEL = var.log_level
  }
  secrets = {
    MY_SECRET = module.secretsmanager_secrets.secrets.my_secret.arn,
  }
}

module "eventbridge_rule" {
  source = "./terraform/modules/eventbridge"

  env      = var.env
  nickname = var.nickname
  tags     = var.tags

  # rule
  rule_name           = "submit-batch-job-rule"
  rule_description    = "Submit a Batch job as scheduled"
  schedule_expression = var.schedule_expression
  is_enabled          = true
  rule_input          = "{}"
  # rule target
  target_arn                      = module.batch.batch_job_queue.id
  role_arn                        = module.cw_event_trigger_batch_role.iam_role.arn
  batch_target_job_definition_arn = module.batch.batch_job_definition.arn
  job_name                        = "triggered-via-eventbridge"
}
