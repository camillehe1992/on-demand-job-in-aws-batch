resource "aws_iam_role" "role" {
  name               = "${var.nickname}-${var.role_name}"
  description        = var.role_description
  assume_role_policy = var.assume_role_policy_document
}

resource "aws_iam_role_policy_attachment" "managed_policy_attachment" {
  for_each = var.aws_managed_policy_arns

  role       = aws_iam_role.role.name
  policy_arn = each.key
}

resource "aws_iam_policy" "customized_policy" {
  for_each = var.customized_policies

  name   = "${var.env}-${var.nickname}-${var.role_name}-${each.key}"
  policy = each.value
}

resource "aws_iam_role_policy_attachment" "customized_policy_attachment" {
  for_each = aws_iam_policy.customized_policy

  role       = aws_iam_role.role.name
  policy_arn = each.value.arn
}

resource "aws_iam_instance_profile" "role_profile" {
  count = var.has_iam_instance_profile ? 1 : 0
  name  = "${var.env}-${var.nickname}-${var.role_name}"
  role  = aws_iam_role.role.name
}
