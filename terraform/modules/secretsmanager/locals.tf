locals {
  prefix = "/${var.nickname}/${var.env}/${data.aws_region.current.name}"
}
