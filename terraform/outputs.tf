output "server_public_ip" {
  value = upcloud_server.app.network_interface[0].ip_address
}

output "db_host" {
  value = upcloud_managed_database_postgresql.main.service_host
}

output "db_port" {
  value = upcloud_managed_database_postgresql.main.service_port
}

output "db_name" {
  value = upcloud_managed_database_postgresql.main.primary_database
}

output "db_username" {
  value = upcloud_managed_database_postgresql.main.service_username
}

output "db_password" {
  sensitive = true
  value     = upcloud_managed_database_postgresql.main.service_password
}

output "db_uri" {
  sensitive = true
  value     = upcloud_managed_database_postgresql.main.service_uri
}
