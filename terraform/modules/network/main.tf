terraform {
  required_providers {
    upcloud = {
      source = "UpCloudLtd/upcloud"
    }
  }
}

resource "upcloud_router" "main" {
  name = "router-${var.environment}"
}

resource "upcloud_network" "private" {
  name   = "private-net-${var.environment}"
  zone   = var.zone
  router = upcloud_router.main.id

  ip_network {
    address            = var.cidr
    dhcp               = true
    dhcp_default_route = false
    family             = "IPv4"
  }
}
