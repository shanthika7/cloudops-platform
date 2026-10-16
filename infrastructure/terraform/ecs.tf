data "aws_caller_identity" "current" {}
resource "aws_ecs_cluster" "cloudops_cluster" {
  name = "cloudops-cluster"

  tags = {
    Name = "cloudops-cluster"
  }
}

resource "aws_ecs_task_definition" "bank_app" {
  family                   = "bank-app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = "256"
  memory = "1024"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "bank-app"
      image     = "${aws_ecr_repository.bank_app.repository_url}:latest"
      essential = true

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.bank_app.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "bank-app"
        }
      }

      dependsOn = [
        {
          containerName = "mysql"
          condition     = "HEALTHY"
        }
      ]
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "DB_HOST"
          value = "localhost"
        },
        {
          name  = "SPRING_DATASOURCE_USERNAME"
          value = "root"
        }
      ]

      secrets = [
        {
          name      = "SPRING_DATASOURCE_PASSWORD"
          valueFrom = "arn:aws:ssm:us-east-1:${data.aws_caller_identity.current.account_id}:parameter/cloudops/mysql/root-password"
        }
      ]
    },

    {
      name      = "mysql"
      image     = "mysql:8.4"
      essential = true

      healthCheck = {
        command = [
          "CMD-SHELL",
          "mysqladmin ping -h localhost -uroot -p$MYSQL_ROOT_PASSWORD || exit 1"
        ]
        interval    = 10
        timeout     = 5
        retries     = 5
        startPeriod = 30
      }

      portMappings = [
        {
          containerPort = 3306
          hostPort      = 3306
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "MYSQL_DATABASE"
          value = "bankappdb"
        }
      ]

      secrets = [
        {
          name      = "MYSQL_ROOT_PASSWORD"
          valueFrom = "arn:aws:ssm:us-east-1:${data.aws_caller_identity.current.account_id}:parameter/cloudops/mysql/root-password"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "bank_app_service" {
  name                              = "bank-app-service"
  cluster                           = aws_ecs_cluster.cloudops_cluster.id
  task_definition                   = aws_ecs_task_definition.bank_app.arn
  desired_count                     = 1
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 120

  network_configuration {
    subnets = [
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id
    ]

    security_groups = [
      aws_security_group.ecs_sg.id
    ]

    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.bank_app_tg.arn
    container_name   = "bank-app"
    container_port   = 8080
  }

  depends_on = [
    aws_lb_listener.http_listener
  ]
}