variable "db_name" {
  description = "Database name"
  type        = string
  default     = "cs_project"
}

variable "db_username" {
  description = "Database admin username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database admin password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Type of RDS instance"
  type        = string
  default     = "db.t3.micro"
}
