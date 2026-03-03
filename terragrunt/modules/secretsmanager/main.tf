locals {
  aws_managed_key_alias = "aws/secretsmanager"
}

data "aws_region" "current" {}

# Use default AWS managed key if not specified
data "aws_kms_key" "by_alias" {
  count = var.kms_key_alias == null ? 1 : 0

  key_id = local.aws_managed_key_alias
}

# Create custom KMS key if specified
resource "aws_kms_key" "cmk_key" {
  count = var.kms_key_alias != null ? 1 : 0

  description             = "KMS CMK key for secrets encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = var.tags
}

resource "aws_secretsmanager_secret" "secrets" {
  for_each = var.secret_specs

  description             = each.value.description
  name                    = upper("${var.secret_prefix}/${each.key}")
  recovery_window_in_days = 7
  kms_key_id              = var.kms_key_alias == null ? data.aws_kms_key.by_alias[0].arn : aws_kms_key.cmk_key[0].arn

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "versions" {
  for_each = var.secret_specs

  secret_id     = aws_secretsmanager_secret.secrets[each.key].id
  secret_string = each.value.secret_string
}
