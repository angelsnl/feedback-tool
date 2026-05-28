output "network_id" {
  value = upcloud_network.private.id
}

output "cidr" {
  value = var.cidr
}
