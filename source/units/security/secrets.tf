# module "secrets" {
#   source = "../../modules/secretsmanager"

#   secret_prefix = local.secret_name_prefix
#   secret_specs = {
#     my_secret = {
#       description   = "A sample secure token that is used in the container, e.g password"
#       secret_string = "MY_SECRET"
#     }
#   }
#   tags = var.tags
# }
