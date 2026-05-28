output "service_uri" {
  sensitive = true
  value     = upcloud_managed_database_postgresql.main.service_uri
}

output "service_host" {
  value = upcloud_managed_database_postgresql.main.service_host
}

output "service_port" {
  value = upcloud_managed_database_postgresql.main.service_port
}

output "primary_database" {
  value = upcloud_managed_database_postgresql.main.primary_database
}

output "service_username" {
  value = upcloud_managed_database_postgresql.main.service_username
}

output "service_password" {
  sensitive = true
  value     = upcloud_managed_database_postgresql.main.service_password
}
