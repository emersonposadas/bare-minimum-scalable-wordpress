provider "aws" {
  region = var.region
}

resource "aws_security_group" "lb_sg" {
  name        = "${var.prefix}-lb-sg"
  description = "security group for the load balancer"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = var.vpc
}

resource "aws_lb_target_group" "hkw_tg" {
  name                 = "${var.prefix}-lb-tg"
  port                 = 443
  protocol             = "HTTPS"
  target_type          = "instance"
  deregistration_delay = 5
  health_check {
    path                = "/wp-admin"
    healthy_threshold   = 2
    interval            = 15
    unhealthy_threshold = 2
    protocol            = "HTTPS"
  }
  vpc_id = var.vpc
}

resource "aws_lb" "main" {
  name               = "${var.prefix}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.lb_sg.id}"]
  subnets            = var.subnets

  enable_deletion_protection = false

  tags = {
    Environment = "hkw"
  }
}
