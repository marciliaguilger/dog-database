provider "aws" {
  region  = "us-east-1"
  profile = "dog"
}

resource "aws_db_instance" "order_db" {
  allocated_storage    = 20
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  db_name                 = "DogOrder"
  username             = "<USER>"
  password             = "<PASSWORD>"  
  db_subnet_group_name = var.rds_subnet_group_name
  vpc_security_group_ids = [var.rds_sg_id]
  publicly_accessible  = false
  skip_final_snapshot  = true  

  tags = {
    Name = "order-rds-instance"
  }
}