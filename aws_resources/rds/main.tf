provider "aws" {
  region = var.region
}

resource "aws_security_group" "db_sg" {
  name        = "${var.prefix}-db-sg"
  description = "security group for the database"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24",
                   "10.0.1.0/24",
                   "10.0.2.0/24",
                  ]
  }

  vpc_id = var.vpc
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "databases"
  subnet_ids = "${var.subnets}" # private subnet

  tags = {
    Name = "DB subnet group"
  }
}

resource "aws_db_instance" "db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mariadb"
  engine_version       = "10.2.21"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  identifier           = ""
  username             = ""
  password             = ""
  parameter_group_name = "mariadb102"
  db_subnet_group_name = "databases"
  skip_final_snapshot  = "true"
}
