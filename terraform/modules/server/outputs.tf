output "public_ip" {
  value = upcloud_server.app.network_interface[0].ip_address
}
