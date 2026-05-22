resource "upcloud_server" "app" {
  title = "Trainee Test Server"
  hostname = "trainee-test-server"
  zone     = var.zone
  plan     = "1xCPU-1GB"
  metadata = true

  template {
    storage = "Ubuntu Server 24.04 LTS (Noble Numbat)"
    size    = 25
  }

  network_interface {
    type = "public"
  }

  network_interface {
    type    = "private"
    network = upcloud_network.private.id
  }

  login {
    user = "ubuntu"
    keys = [file(pathexpand("~/.ssh/id_ed25519.pub"))]
  }
}
