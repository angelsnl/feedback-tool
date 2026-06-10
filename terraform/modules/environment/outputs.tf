output "server_public_ip" {
  value = module.server.public_ip
}

# output "db_host" {
#   value = module.database.service_host
# }

# output "db_port" {
#   value = module.database.service_port
# }

# output "db_name" {
#   value = module.database.primary_database
# }

# output "db_username" {
#   value = module.database.service_username
# }

# output "db_password" {
#   sensitive = true
#   value     = module.database.service_password
# }

# output "db_uri" {
#   sensitive = true
#   value     = module.database.service_uri
# }
