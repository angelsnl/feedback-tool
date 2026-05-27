resource "upcloud_managed_database_postgresql" "main" {
  name  = "postgres-${local.environment}"
  title = "PostgreSQL ${local.environment}"
  plan  = "1x1xCPU-2GB-25GB"
  zone  = var.zone

  network {
    family = "IPv4"
    name   = "private"
    type   = "private"
    uuid   = upcloud_network.private.id
  }

  properties {
    ip_filter = ["10.0.0.0/24"]
  }
}
