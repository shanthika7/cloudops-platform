output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.bank_app.repository_url
}