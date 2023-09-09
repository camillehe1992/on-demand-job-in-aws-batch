output "iam_role" {
  value = {
    arn = aws_iam_role.role.arn
    id  = aws_iam_role.role.id
  }
}
