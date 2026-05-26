resource "upcloud_router" "main" {
  for_each = local.environments
  name     = "router-${each.key}"
}

resource "upcloud_network" "private" {
  for_each = local.environments
  name     = "private-net-${each.key}"
  zone     = var.zone
  router   = upcloud_router.main[each.key].id

  ip_network {
    address            = "10.0.0.0/24"
    dhcp               = true
    dhcp_default_route = false
    family             = "IPv4"
  }
}
