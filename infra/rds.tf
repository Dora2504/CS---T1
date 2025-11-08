# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get default security group
data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "default"
}

resource "aws_db_instance" "postgres" {
  identifier              = "rds-postgres-academy"
  engine                  = "postgres"
  instance_class          = var.db_instance_class
  allocated_storage       = 20
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  skip_final_snapshot     = true
  publicly_accessible     = true  # Set to true for easier access from Lambda/development
  vpc_security_group_ids  = [data.aws_security_group.default.id]
  # Remove db_subnet_group_name to use default subnet group

  tags = {
    Name = "RDS-Postgres-Academy"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [
      # Ignora mudanças que causam conflito
      identifier,
      db_name,
      username,
      password
    ]
  }
}
