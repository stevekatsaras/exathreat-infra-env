resource "aws_lb" "private_web" {
  name               = format("%s-alb-priv-web", local.NameTag)
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.lb.id]
  subnets            = [data.aws_subnet.private_weba.id, data.aws_subnet.private_webb.id]
  tags = {
    Name  = format("%s-alb-priv-web", local.NameTag)
    Owner = var.Owner
  }
}

# ALB Listener (external)
resource "aws_lb_listener" "private_web" {
  load_balancer_arn = aws_lb.private_web.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.exathreat_com.arn
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "portal" {
  listener_arn = aws_lb_listener.private_web.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.portal.arn

  }
  condition {
    path_pattern {
      values = ["/portal*"]
    }
  }
}

resource "aws_lb_target_group" "portal" {
  name        = format("%s-tg-portal", local.NameTag)
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.vpc.id
  target_type = "ip"
  health_check {
    interval = 120
    timeout  = 60
    path     = "/portal/actuator/health"
    matcher  = 200

  }
  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 3600
  }
}

resource "aws_lb_listener_rule" "api" {
  listener_arn = aws_lb_listener.private_web.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api.id
  }
  condition {
    path_pattern {
      values = ["/api*"]
    }
  }
}

resource "aws_lb_target_group" "api" {
  name        = format("%s-tg-api", local.NameTag)
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.vpc.id
  target_type = "ip"
  health_check {
    interval = 120
    timeout  = 60
    path     = "/api/actuator/health"
    matcher  = 200
  }
}