resource "upcloud_server" "app" {
  title    = "Trainee Test Server"
  hostname = "trainee-test-server"
  zone     = var.zone
  plan     = "1xCPU-1GB"
  metadata = true

  template {
    storage = "Ubuntu Server 24.04 LTS (Noble Numbat)"
    size    = 10
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
    keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDUgKr4od5isNltQuHZwkm/tiEyYL4XDssQnDyxHXPln github",
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDGxqyhR02yclevvbcgeWNIzpdwZX/OORGkuoiTvxq/P jook@maxos-work",
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXFkMEYw69Gp/2flL0XgvGZUJAZ7dM3baKDBPWWzNLm vike@macbook-work",
    ]
  }
}
