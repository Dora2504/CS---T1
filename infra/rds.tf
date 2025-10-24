resource "aws_db_instance" "postgres" {
  identifier              = "rds-postgres-academy"
  engine                  = "postgres"
  instance_class          = var.db_instance_class
  allocated_storage       = 20
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  publicly_accessible     = false
  vpc_security_group_ids  = ["sg-09c9b3f17f3e26e35"]
  db_subnet_group_name    = "default-vpc-09688a9154e0f9956"

  tags = {
    Name = "RDS-Postgres-Academy"
  }
}
