resource "aws_ecr_repository" "lambda_repo" {
  name                 = "cs-t1-springboot-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
