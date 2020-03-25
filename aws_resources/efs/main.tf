provider "aws" {
  region = var.region
}

resource "aws_efs_file_system" "main" {
  creation_token   = "sharedstorage"
  performance_mode = "generalPurpose"

  tags = {
    Name = "${var.prefix}-storage"
  }
}

resource "aws_efs_mount_target" "alpha" {
  file_system_id = "${aws_efs_file_system.main.id}"
  subnet_id      = "subnet-0e00630442db9b6b1" # us-west-2b
  security_groups = ["${aws_security_group.efs_sg.id}"]
}

resource "aws_efs_mount_target" "beta" {
  file_system_id = "${aws_efs_file_system.main.id}"
  subnet_id      = "subnet-062d1eb22fd53730c" # us-west-2c
  security_groups = ["${aws_security_group.efs_sg.id}"]
}

resource "aws_security_group" "efs_sg" {
  name        = "${var.prefix}-efs-sg"
  description = "security group for the EFS"

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  }

  vpc_id = var.vpc
}
