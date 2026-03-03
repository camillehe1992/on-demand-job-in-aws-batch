output "secrets" {
  value = {
    for key, secret in aws_secretsmanager_secret_version.versions : key => {
      arn = secret.arn
    }
  }
}

output "kms_key" {
  value = {
    arn = var.kms_key_alias == null ? data.aws_kms_key.by_alias[0].arn : aws_kms_key.cmk_key[0].arn
  }
}
