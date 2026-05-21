output "server_ip" {
  description = "App server public IP"
  value       = upcloud_server.app.network_interface[0].ip_address
}

output "db_service_uri" {
  description = "PostgreSQL connection string (use as DATABASE_URL)"
  value       = upcloud_managed_database_postgresql.db.service_uri
  sensitive   = true
}

output "db_host" {
  description = "PostgreSQL host"
  value       = upcloud_managed_database_postgresql.db.service_host
}

output "db_port" {
  description = "PostgreSQL port"
  value       = upcloud_managed_database_postgresql.db.service_port
}
