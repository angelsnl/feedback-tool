terraform {
  required_providers {
    upcloud = {
      source = "UpCloudLtd/upcloud"
    }
  }
}

resource "upcloud_managed_database_postgresql" "main" {
  name  = "postgres-${var.environment}"
  title = "PostgreSQL ${var.environment}"
  plan  = var.plan
  zone  = var.zone

  network {
    family = "IPv4"
    name   = "private"
    type   = "private"
    uuid   = var.private_network_id
  }

  properties {
    ip_filter = [var.private_network_cidr]
  }
}
