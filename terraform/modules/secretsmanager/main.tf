data "aws_region" "current" {}

resource "aws_secretsmanager_secret" "secrets" {
  for_each = var.secret_specs

  description             = each.value.description
  name                    = upper("${local.prefix}/${each.key}")
  recovery_window_in_days = 0

  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "versions" {
  for_each   = var.secret_specs
  depends_on = [aws_secretsmanager_secret.secrets]

  secret_id     = aws_secretsmanager_secret.secrets[each.key].id
  secret_string = each.value.secret_string
}
