data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

locals {
  aws_batch_service_role_arn      = "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/batch.amazonaws.com/AWSServiceRoleForBatch"
  batch_instance_role_profile_arn = replace(var.instance_role_arn, ":role/", ":instance-profile/")
  environment = [
    for key, value in var.environment : {
      name  = key,
      value = value
    }
  ]
  secrets = [
    for key, value in var.secrets : {
      name      = key,
      valueFrom = value
    }
  ]
}
