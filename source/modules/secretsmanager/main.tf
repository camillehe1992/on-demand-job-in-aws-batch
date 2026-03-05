resource "aws_secretsmanager_secret" "secrets" {
  for_each = var.secret_specs

  description             = each.value.description
  name                    = "${var.secret_prefix}/${each.key}"
  recovery_window_in_days = var.recovery_window_in_days
  kms_key_id              = var.kms_key_id
  tags                    = var.tags
}

resource "aws_secretsmanager_secret_version" "versions" {
  for_each = var.secret_specs

  secret_id     = aws_secretsmanager_secret.secrets[each.key].id
  secret_string = each.value.secret_string
}
