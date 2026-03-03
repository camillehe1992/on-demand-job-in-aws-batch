# module "secrets" {
#   source = "../../modules/secret_manager"

#   env      = var.env
#   nickname = var.nickname
#   tags     = var.tags
#   secret_specs = {
#     my_secret = {
#       description   = "A sample secure token that is used in the container, e.g password"
#       secret_string = "MY_SECRET"
#     }
#   }
# }
