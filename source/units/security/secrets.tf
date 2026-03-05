module "secrets" {
  source = "../../modules/secretsmanager"

  secret_prefix = local.secret_name_prefix
  secret_specs  = var.secret_specs
  tags          = var.tags
}
