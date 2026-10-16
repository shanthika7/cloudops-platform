resource "aws_iam_role_policy" "ecs_ssm_parameter_access" {
  name = "cloudops-ecs-ssm-parameter-access"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ssm:GetParameters"
        ]

        Resource = "arn:aws:ssm:us-east-1:*:parameter/cloudops/mysql/root-password"
      }
    ]
  })
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "cloudops-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
