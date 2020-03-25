provider "aws" {
  region = var.region
}

resource "aws_security_group" "web_sg" {
  name        = "${var.prefix}-web-sg"
  description = "security group for the app"

  ingress {
    from_port = 1338
    to_port   = 1338
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["10.0.0.0/24",
                   "10.0.1.0/24",
                   "10.0.2.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc
}

resource "aws_launch_configuration" "web_lc" {
  name                        = "${var.prefix}-web-lc"
  image_id                    = var.ami
  instance_type               = var.instance_type
  security_groups             = ["${aws_security_group.web_sg.id}"]
  iam_instance_profile        = "hkw_profile"
  associate_public_ip_address = "true"
}

resource "aws_autoscaling_group" "web_asg" {
  availability_zones = ["${var.region}b", "${var.region}c"]
  name               = "${var.prefix}-web-asg"
  max_size           = var.max_size
  min_size           = var.min_size
  vpc_zone_identifier = ["subnet-0e00630442db9b6b1", # private subnet b
  "subnet-062d1eb22fd53730c"]
  health_check_type    = "EC2"
  target_group_arns    = ["arn:aws:elasticloadbalancing:us-west-2:id:targetgroup/hkw-lb-tg/id"]
  launch_configuration = aws_launch_configuration.web_lc.name
  tags = [
    {
      key                 = "Name"
      value               = "${var.prefix}-web-instance"
      propagate_at_launch = true
    },
  ]
  termination_policies      = ["NewestInstance"]
  enabled_metrics           = [
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances",
  ]
}

resource "aws_autoscaling_policy" "up" {
  name                   = "${var.prefix}-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  cooldown               = "10"
}

resource "aws_cloudwatch_metric_alarm" "memory_high" {
  alarm_name                = "HighMemoryUtilization_${var.prefix}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  datapoints_to_alarm       = "2"
  metric_name               = "MemoryUtilization"
  namespace                 = "System/Linux"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = var.max_memory
  alarm_description         = "This metric monitors ec2 memory high utilization"
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.web_asg.name}"
  }
  alarm_actions     = ["${aws_autoscaling_policy.up.arn}"]
  insufficient_data_actions = []
}

resource "aws_autoscaling_policy" "down" {
  name                   = "${var.prefix}-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  cooldown               = "300"
}

resource "aws_cloudwatch_metric_alarm" "memory_low" {
  alarm_name                = "LowMemoryUtilization_${var.prefix}"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "5"
  datapoints_to_alarm       = "5"
  metric_name               = "MemoryUtilization"
  namespace                 = "System/Linux"
  period                    = "60"
  statistic                 = "Maximum"
  threshold                 = var.min_memory
  alarm_description         = "This metric monitors ec2 memory low utilization"
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.web_asg.name}"
  }
  alarm_actions     = ["${aws_autoscaling_policy.down.arn}"]
  insufficient_data_actions = []
}
