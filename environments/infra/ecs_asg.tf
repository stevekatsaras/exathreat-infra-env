## Portal

resource "aws_appautoscaling_target" "ecs_target_portal" {
  max_capacity       = var.portal_asg_max
  min_capacity       = var.portal_asg_min
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.portal.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


resource "aws_appautoscaling_policy" "ecs_policy_memory_portal" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_portal.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_portal.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_portal.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu_portal" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_portal.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_portal.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_portal.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 60
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

## Api

resource "aws_appautoscaling_target" "ecs_target_api" {
  max_capacity       = var.api_asg_max
  min_capacity       = var.api_asg_min
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.api.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


resource "aws_appautoscaling_policy" "ecs_policy_memory_api" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_api.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_api.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_api.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu_api" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target_api.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target_api.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target_api.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 60
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}