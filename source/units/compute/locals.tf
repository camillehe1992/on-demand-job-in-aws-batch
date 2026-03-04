locals {
  aws_region                      = data.aws_region.current.region
  aws_account_id                  = data.aws_caller_identity.current.account_id
  aws_partition                   = data.aws_partition.current.partition
  aws_batch_service_role_arn      = "arn:${local.aws_partition}:iam::${local.aws_account_id}:role/aws-service-role/batch.amazonaws.com/AWSServiceRoleForBatch"
  batch_instance_role_profile_arn = replace(var.instance_role_arn, ":role/", ":instance-profile/")
  resource_prefix                 = "${var.env}-${var.application_name}"
}
