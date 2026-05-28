terraform {
  required_providers {
    upcloud = {
      source = "UpCloudLtd/upcloud"
    }
  }
}

resource "upcloud_server" "app" {
  title    = "Trainee Server ${var.environment}"
  hostname = "trainee-server-${var.environment}"
  zone     = var.zone
  plan     = var.plan
  metadata = true

  template {
    storage = var.storage_template
    size    = var.storage_size
  }

  network_interface {
    type = "public"
  }

  network_interface {
    type    = "private"
    network = var.private_network_id
  }

  login {
    user = "ubuntu"
    keys = concat([var.deploy_public_key], var.ssh_public_keys)
  }

  user_data = <<-EOT
    #!/bin/bash
    set -e

    apt-get update
    apt-get install -y ca-certificates curl
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
      | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    usermod -aG docker ubuntu

    mkdir -p /opt/feedback-tool
    chown ubuntu:ubuntu /opt/feedback-tool

    systemctl enable docker
    systemctl start docker
  EOT
}
