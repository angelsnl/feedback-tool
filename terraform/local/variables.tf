variable "pg_host" {
  description = "Local PostgreSQL host"
  type        = string
  default     = "localhost"
}

variable "pg_port" {
  description = "Local PostgreSQL port"
  type        = number
  default     = 5432
}

variable "pg_superuser" {
  description = "Superuser for provisioning (e.g. postgres)"
  type        = string
  default     = "postgres"
}

variable "pg_superuser_password" {
  description = "Superuser password (empty string if peer/trust auth)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "app_db_name" {
  description = "Database name for the app"
  type        = string
  default     = "form_app"
}

variable "app_db_user" {
  description = "Role name for the app"
  type        = string
  default     = "form_app"
}

variable "app_db_password" {
  description = "Password for the app role"
  type        = string
  sensitive   = true
}
