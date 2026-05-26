output "server_public_ip" {
  description = "Public IP address per environment"
  value       = { for env, s in upcloud_server.app : env => s.network_interface[0].ip_address }
}

output "db_host" {
  description = "PostgreSQL hostname per environment"
  value       = { for env, db in upcloud_managed_database_postgresql.main : env => db.service_host }
}

output "db_port" {
  description = "PostgreSQL port per environment"
  value       = { for env, db in upcloud_managed_database_postgresql.main : env => db.service_port }
}

output "db_name" {
  description = "Default database name per environment"
  value       = { for env, db in upcloud_managed_database_postgresql.main : env => db.primary_database }
}

output "db_username" {
  description = "PostgreSQL admin username per environment"
  value       = { for env, db in upcloud_managed_database_postgresql.main : env => db.service_username }
}

output "db_password" {
  description = "PostgreSQL admin password per environment"
  sensitive   = true
  value       = { for env, db in upcloud_managed_database_postgresql.main : env => db.service_password }
}

output "db_uri" {
  description = "Full PostgreSQL connection URI per environment"
  sensitive   = true
  value       = { for env, db in upcloud_managed_database_postgresql.main : env => db.service_uri }
}
