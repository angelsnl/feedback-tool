terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "~> 1.22"
    }
  }
}

provider "postgresql" {
  host     = var.pg_host
  port     = var.pg_port
  username = var.pg_superuser
  password = var.pg_superuser_password
  sslmode  = "disable"
}

resource "postgresql_role" "app" {
  name     = var.app_db_user
  login    = true
  password = var.app_db_password
}

resource "postgresql_database" "app" {
  name  = var.app_db_name
  owner = postgresql_role.app.name
}
