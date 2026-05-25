resource "upcloud_router" "main" {
  name = "trainee-test-router"
}

resource "upcloud_network" "private" {
  name   = "trainee-test-private-net"
  zone   = var.zone
  router = upcloud_router.main.id

  ip_network {
    address            = "10.0.0.0/24"
    dhcp               = true
    dhcp_default_route = false
    family             = "IPv4"
  }
}
