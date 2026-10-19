resource "aws_ecr_repository" "bank_app" {
  name         = var.ecr_repository_name
  force_delete = true
}

resource "aws_ecr_lifecycle_policy" "bank_app_lifecycle" {
  repository = aws_ecr_repository.bank_app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"

        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }

        action = {
          type = "expire"
        }
      }
    ]
  })
}