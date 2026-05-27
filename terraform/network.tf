resource "upcloud_router" "main" {
  name = "router-${local.environment}"
}

resource "upcloud_network" "private" {
  name   = "private-net-${local.environment}"
  zone   = var.zone
  router = upcloud_router.main.id

  ip_network {
    address            = "10.0.0.0/24"
    dhcp               = true
    dhcp_default_route = false
    family             = "IPv4"
  }
}
