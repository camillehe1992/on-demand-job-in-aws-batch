output "secrets" {
  value = {
    for key, secret in aws_secretsmanager_secret_version.versions : key => {
      arn = secret.arn
    }
  }
}
