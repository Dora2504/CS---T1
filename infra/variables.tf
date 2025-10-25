variable "db_name" {
  description = "Database name"
  type        = string
  default     = "cs_project"
}

variable "db_username" {
  description = "Database admin username"
  type        = string
  sensitive   = true
  default = "dbadmin"
}

variable "db_password" {
  description = "Database admin password"
  type        = string
  sensitive   = true
  default = "SenhaMuitoSegura123" 
}

variable "db_instance_class" {
  description = "Type of RDS instance"
  type        = string
  default     = "db.t3.micro"
}


variable "project_name" {
  description = "Prefixo para os nomes dos recursos (ex: nome-do-projeto)"
  type        = string
  default     = "java-lambda-spring-boot"
}

variable "image_tag" {
  description = "Tag para a imagem do Docker (ex: latest, v1.0.0)"
  type        = string
  default     = "latest"
}

// Adicione em variables.tf

variable "aws_account_id" {
  description = "ID da Conta AWS (12 dígitos)"
  type        = string
  default     = "843483113908" 
}