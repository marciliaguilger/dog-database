provider "aws" {
  region  = "us-east-1"
  profile = "pos"
}

data "aws_secretsmanager_secret" "rds_postgres_credentials" {
  name = "rds/postgres/dog-restaurant/credentials"
}

data "aws_secretsmanager_secret_version" "rds_postgres_credentials" {
  secret_id = data.aws_secretsmanager_secret.rds_postgres_credentials.id
}

locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.rds_postgres_credentials.secret_string)
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-mysql-sg"
  description = "Allow MySQL access"
  vpc_id      = <vpc>

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-mysql-sg"
  }
}

resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "dogrestaurantdb"
  username             = local.db_credentials.username
  password             = local.db_credentials.password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

  # Associa o Security Group à instância do RDS
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  publicly_accessible  = true
  backup_retention_period = 0

  tags = {
    Name = "DogRestaurantInstance"
  }
}
