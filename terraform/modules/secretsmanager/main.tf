data "aws_region" "current" {}

resource "aws_secretsmanager_secret" "secrets" {
  for_each = var.secret_specs

  description             = each.value.description
  name                    = upper("${local.prefix}/${each.key}")
  recovery_window_in_days = 7                           # 最小安全值，防止意外删除
  kms_key_id              = aws_kms_key.secrets_key.arn # 使用客户管理的KMS密钥

  tags = var.tags
}

# 创建KMS密钥用于Secrets Manager加密
resource "aws_kms_key" "secrets_key" {
  description             = "KMS key for ${var.env}-${var.nickname} secrets encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(var.tags, {
    Name = "${var.env}-${var.nickname}-secrets-key"
  })
}

resource "aws_kms_alias" "secrets_key_alias" {
  name          = "alias/${var.env}-${var.nickname}-secrets"
  target_key_id = aws_kms_key.secrets_key.key_id
}

resource "aws_secretsmanager_secret_version" "versions" {
  for_each   = var.secret_specs
  depends_on = [aws_secretsmanager_secret.secrets]

  secret_id     = aws_secretsmanager_secret.secrets[each.key].id
  secret_string = each.value.secret_string
}
