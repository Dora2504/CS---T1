variable "db_username" {
  description = "PostgreSQL User"
  type        = string
}

variable "db_password" {
  description = "PostgreSQL Password"
  type        = string
  sensitive   = true
}
