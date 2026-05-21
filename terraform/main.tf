terraform {
  required_providers {
    upcloud = {
      source  = "UpCloudLtd/upcloud"
      version = "~> 5.0"
    }
  }
}

provider "upcloud" {
  username = var.upcloud_username
  password = var.upcloud_password
}

data "upcloud_storage" "ubuntu" {
  most_recent = true
  type        = "template"
  name_regex  = "Ubuntu Server 22\\.04"
}

resource "upcloud_managed_database_postgresql" "db" {
  name  = "${var.project_name}-db"
  plan  = "1x1xCPU-2GB-25GB"
  zone  = var.zone
  title = "${var.project_name} PostgreSQL"

  properties {
    public_access = true
    ip_filter     = var.db_allowed_ips
  }
}

resource "upcloud_server" "app" {
  hostname = "${var.project_name}-app"
  plan     = "1xCPU-1GB"
  zone     = var.zone

  template {
    storage = data.upcloud_storage.ubuntu.id
    size    = 25
  }

  network_interface {
    type = "public"
  }

  network_interface {
    type = "utility"
  }

  login {
    user            = "root"
    keys            = [var.ssh_public_key]
    create_password = false
  }
}

resource "upcloud_firewall_rules" "app" {
  server_id = upcloud_server.app.id

  firewall_rule {
    action                 = "accept"
    direction              = "in"
    family                 = "IPv4"
    protocol               = "tcp"
    destination_port_start = "3000"
    destination_port_end   = "3000"
    comment                = "Node app"
  }

  firewall_rule {
    action                 = "accept"
    direction              = "in"
    family                 = "IPv4"
    protocol               = "tcp"
    destination_port_start = "22"
    destination_port_end   = "22"
    source_address_start   = var.admin_ip
    source_address_end     = var.admin_ip
    comment                = "SSH from admin"
  }

  firewall_rule {
    action    = "drop"
    direction = "in"
    comment   = "Drop all other inbound"
  }
}
