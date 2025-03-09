resource "aws_ecs_cluster" "main" {
  name = format("%s-ecs-cluster", local.NameTag)
  tags = {
    Name        = format("%s-ecs-cluster", local.NameTag)
    Environment = var.env
  }
}
