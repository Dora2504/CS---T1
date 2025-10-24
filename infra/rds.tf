resource "aws_db_instance" "postgres" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "13.3"
  instance_class         = "db.t3.micro"
  db_name                = "meubanco"

  # Variáveis para usuário e senha
  username               = var.db_username
  password               = var.db_password

  # IDs de recursos fornecidos pelo instrutor
  vpc_security_group_ids = ["sg-id-fornecido-pelo-instrutor"]
  db_subnet_group_name   = "nome-do-subnet-group-fornecido"

  multi_az               = false
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = {
    Name = "RDS-Postgres-Academy"
  }
}