resource "aws_cloudwatch_log_group" "api" {
  name              = format("/ecs/%s-api", local.NameTag)
  retention_in_days = var.log_retention
  tags = {
    Name        = format("%s-api", local.NameTag)
    Environment = var.env
  }
}

resource "aws_ecs_task_definition" "api" {
  family                   = format("%s-api", local.NameTag)
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.api_cpu
  memory                   = var.api_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name      = "exathreat-api"
    image     = "367480315855.dkr.ecr.ap-southeast-2.amazonaws.com/exathreat-api:latest"
    essential = true
    environment = [
      {
        name  = "PROFILE",
        value = "aws"
      },
      {
        name  = "CACHE_TIMEOUT",
        value = "60000"
      },
      {
        name  = "DB_ADDRESS",
        value = aws_db_instance.exathreat_mysql.address
      },
      {
        name  = "DB_PORT",
        value = "3306"
      },
      {
        name  = "DB_NAME",
        value = "exathreat"
      },
      {
        name  = "DB_USERNAME",
        value = data.aws_ssm_parameter.prod-exathreat-db-user.value # mysql_user.api.user # data.aws_ssm_parameter.prod-exathreat-db-user.value
      },
      {
        name  = "DB_PASSWORD",
        value = data.aws_ssm_parameter.prod-exathreat-db-pw.value
      },
      {
        name  = "ES_DOMAIN",
        value = aws_elasticsearch_domain.elasticsearch.endpoint
      },
      {
        name  = "ES_PORT",
        value = "443"
      },
      {
        name  = "ES_SCHEME",
        value = "https"
      }
    ]
    portMappings = [{
      protocol      = "tcp"
      containerPort = 8080
      hostPort      = 8080
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.api.name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region
      }
    }
  }])

  tags = {
    Name        = format("%s-api", local.NameTag)
    Environment = var.env
  }
}

resource "aws_ecs_service" "api" {
  name                               = format("%s-api-service", local.NameTag)
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.api.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 60
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [data.aws_security_group.api.id]
    subnets          = [data.aws_subnet.private_weba.id, data.aws_subnet.private_webb.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api.arn
    container_name   = "exathreat-api"
    container_port   = 8080
  }

  # we ignore task_definition changes as the revision changes on deploy
  # of a new version of the application
  # desired_count is ignored as it can change due to autoscaling policy
  lifecycle {
    ignore_changes = [desired_count]
  }
}
