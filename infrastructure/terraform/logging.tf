resource "aws_cloudwatch_log_group" "bank_app" {
  name              = "/ecs/bank-app"
  retention_in_days = 7

  tags = {
    Name = "bank-app-logs"
  }
}