resource "aws_launch_template" "my_app_eg2" {
  name                   = "my-app-eg2"
  image_id               = var.ami_id
  key_name               = var.key_name
  vpc_security_group_ids = [var.ec2_eg1_sg_id]
}

resource "aws_lb_target_group" "my_app_eg2" {
  name     = "my-app-eg2"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    unhealthy_threshold = 2
    # timeout             = 10
    interval            = 30
    path                = "/docs"
    protocol            = "HTTP"
    port                = "80"
    matcher             = "200"
  }
}

resource "aws_autoscaling_group" "my_app_eg2" {
  name     = "my-app-eg2"
  min_size = 2
  max_size = 5
  desired_capacity     = 2
  health_check_type = "EC2"

  vpc_zone_identifier = [
    var.private_us_east_1a_id,
    var.private_us_east_1b_id
  ]

  target_group_arns = [aws_lb_target_group.my_app_eg2.arn]

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.my_app_eg2.id
      }
      override {
        instance_type = var.instance_type
      }
    }
  }
}

# resource "aws_autoscaling_policy" "my_app_eg2" {
#   name                   = "my-app-eg2"
#   policy_type            = "TargetTrackingScaling"
#   autoscaling_group_name = aws_autoscaling_group.my_app_eg2.name

#   estimated_instance_warmup = 180

#   target_tracking_configuration {
#     predefined_metric_specification {
#       predefined_metric_type = "ASGAverageCPUUtilization"
#     }

#     target_value = 200
#   }
# }

resource "aws_lb" "my_app_eg2" {
  name               = "my-app-eg2"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_eg1_sg_id]

  subnets = [
    var.public_us_east_1a_id,
    var.public_us_east_1b_id
  ]

  enable_deletion_protection = false
}

resource "aws_lb_listener" "my_app_eg2" {
  load_balancer_arn = aws_lb.my_app_eg2.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_app_eg2.arn
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.my_app_eg2.name
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
  alarm_name          = "cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.my_app_eg2.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.my_app_eg2.name
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_low" {
  alarm_name          = "cpu-utilization-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 20

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.my_app_eg2.name
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_down.arn]
}

resource "aws_cloudwatch_log_group" "my_log_group" {
  name = "/fast-api-app/logs"
}

# locals {
#   web_servers = {
#     my-app-00 = {
#       subnet_id    = var.private_us_east_1a_id
#     }
#     my-app-01 = {
#       subnet_id    = var.private_us_east_1b_id
#     }
#   }
# }

# resource "aws_instance" "my_app_eg1" {
#   for_each = local.web_servers

#   ami           = var.ami_id
#   instance_type = var.instance_type
#   key_name      = var.key_name
#   subnet_id     = each.value.subnet_id

#   vpc_security_group_ids = [var.ec2_eg1_sg_id]

#   tags = {
#     Name = each.key
#   }
# }

# resource "aws_lb_target_group" "my_app_eg1" {
#   name       = "my-app-eg1"
#   port       = 8080
#   protocol   = "HTTP"
#   vpc_id     = var.vpc_id
#   slow_start = 0

#   # load_balancing_algorithm_type = "round_robin"

#   stickiness {
#     enabled = false
#     type    = "lb_cookie"
#   }

#   health_check {
#     enabled             = true
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 10
#     interval            = 30
#     path                = "/docs"
#     protocol            = "HTTP"
#     port                = "80"
#   }
# }

# resource "aws_lb_target_group_attachment" "my_app_eg1" {
#   for_each = aws_instance.my_app_eg1

#   target_group_arn = aws_lb_target_group.my_app_eg1.arn
#   target_id        = each.value.id
#   port             = 80
# }

# resource "aws_lb" "my_app_eg1" {
#   name               = "my-app-eg1"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [var.alb_eg1_sg_id]

#   # access_logs {
#   #   bucket  = "my-logs"
#   #   prefix  = "my-app-lb"
#   #   enabled = true
#   # }

#   subnets = [
#     var.public_us_east_1a_id,
#     var.public_us_east_1b_id
#   ]
# }

# resource "aws_lb_listener" "http_eg1" {
#   load_balancer_arn = aws_lb.my_app_eg1.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.my_app_eg1.arn
#   }
# }
