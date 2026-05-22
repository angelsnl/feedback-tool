output "server_public_ip" {
  description = "Public IP address of the app server"
  value       = upcloud_server.app.network_interface[0].ip_address
}

output "db_host" {
  description = "PostgreSQL service hostname"
  value       = upcloud_managed_database_postgresql.main.service_host
}

output "db_port" {
  description = "PostgreSQL service port"
  value       = upcloud_managed_database_postgresql.main.service_port
}

output "db_name" {
  description = "Default database name"
  value       = upcloud_managed_database_postgresql.main.primary_database
}

output "db_username" {
  description = "PostgreSQL admin username"
  value       = upcloud_managed_database_postgresql.main.service_username
}

output "db_password" {
  description = "PostgreSQL admin password"
  value       = upcloud_managed_database_postgresql.main.service_password
  sensitive   = true
}

output "db_uri" {
  description = "Full PostgreSQL connection URI"
  value       = upcloud_managed_database_postgresql.main.service_uri
  sensitive   = true
}
