resource "aws_lb" "cloudops_alb" {
  name               = "cloudops-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]

  tags = {
    Name = "cloudops-alb"
  }
}

resource "aws_lb_target_group" "bank_app_tg" {
  name        = "bank-app-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.cloudops_vpc.id
  target_type = "ip"

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name = "bank-app-target-group"
  }
}
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.cloudops_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bank_app_tg.arn
  }
}