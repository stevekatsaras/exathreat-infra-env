resource "aws_cloudwatch_log_group" "intel" {
  name              = format("/ecs/%s-intel", local.NameTag)
  retention_in_days = var.log_retention
  tags = {
    Name        = format("%s-intel", local.NameTag)
    Environment = var.env
  }
}

resource "aws_ecs_task_definition" "intel" {
  family                   = format("%s-intel", local.NameTag)
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name      = "exathreat-intel"
    image     = "367480315855.dkr.ecr.ap-southeast-2.amazonaws.com/exathreat-intel:latest"
    essential = true
    environment = [
      {
        name  = "PROFILE",
        value = "aws"
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
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.intel.name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region
      }
    }
  }])

  tags = {
    Name        = format("%s-intel", local.NameTag)
    Environment = var.env
  }
}

resource "aws_ecs_service" "intel" {
  name                               = format("%s-intel-service", local.NameTag)
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.intel.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [data.aws_security_group.intel.id]
    subnets          = [data.aws_subnet.private_weba.id, data.aws_subnet.private_webb.id]
    assign_public_ip = true
  }

  # we ignore task_definition changes as the revision changes on deploy
  # of a new version of the application
  # desired_count is ignored as it can change due to autoscaling policy
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}
