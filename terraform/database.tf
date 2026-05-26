resource "upcloud_managed_database_postgresql" "main" {
  for_each = local.environments
  name     = "postgres-${each.key}"
  title    = "PostgreSQL ${each.key}"
  plan     = "1x1xCPU-2GB-25GB"
  zone     = var.zone

  network {
    family = "IPv4"
    name   = "private"
    type   = "private"
    uuid   = upcloud_network.private[each.key].id
  }

  properties {
    ip_filter = ["10.0.0.0/24"]
  }
}
