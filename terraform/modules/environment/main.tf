resource "tls_private_key" "deploy" {
  algorithm = "ED25519"
}

module "network" {
  source      = "../network"
  environment = var.environment
  zone        = var.zone
}

module "database" {
  source               = "../database"
  environment          = var.environment
  zone                 = var.zone
  private_network_id   = module.network.network_id
  private_network_cidr = module.network.cidr
}

module "server" {
  source             = "../server"
  environment        = var.environment
  zone               = var.zone
  private_network_id = module.network.network_id
  deploy_public_key  = tls_private_key.deploy.public_key_openssh
  ssh_public_keys    = var.ssh_public_keys
}

module "github" {
  source             = "../github"
  environment        = var.environment
  github_repository  = var.github_repository
  deploy_private_key = tls_private_key.deploy.private_key_openssh
  database_url       = module.database.service_uri
  server_public_ip   = module.server.public_ip
}
