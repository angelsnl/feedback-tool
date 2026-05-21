output "database_url" {
  description = "DATABASE_URL connection string for the app"
  value       = "postgresql://${var.app_db_user}:${var.app_db_password}@${var.pg_host}:${var.pg_port}/${var.app_db_name}?sslmode=disable"
  sensitive   = true
}
