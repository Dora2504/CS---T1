resource "aws_db_subnet_group" "default" {
  name       = "terraform-rds-subnet"
  subnet_ids = [aws_subnet.public_subnet.id]
}

resource "aws_db_instance" "postgres" {
  identifier         = "terraform-postgres"
  engine             = "postgres"
  engine_version     = "15.14"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  name               = "mydatabase"
  username           = var.db_username
  password           = var.db_password
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot = true
}
