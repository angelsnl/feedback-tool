terraform {
  required_providers {
    upcloud = {
      source  = "UpCloudLtd/upcloud"
      version = "~> 5.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.3"
  cloud {
    organization = "pepes-angels-test"
    workspaces {
      name = "feedback-tool-dev"
    }
  }
}

provider "upcloud" {
  token = var.upcloud_token
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

locals {
  environment = "dev"
}

resource "tls_private_key" "deploy" {
  algorithm = "ED25519"
}

module "network" {
  source      = "../../modules/network"
  environment = local.environment
  zone        = var.zone
}

module "database" {
  source               = "../../modules/database"
  environment          = local.environment
  zone                 = var.zone
  private_network_id   = module.network.network_id
  private_network_cidr = module.network.cidr
}

module "server" {
  source             = "../../modules/server"
  environment        = local.environment
  zone               = var.zone
  private_network_id = module.network.network_id
  deploy_public_key  = tls_private_key.deploy.public_key_openssh
  ssh_public_keys    = var.ssh_public_keys
}

module "github" {
  source             = "../../modules/github"
  environment        = local.environment
  github_repository  = var.github_repository
  deploy_private_key = tls_private_key.deploy.private_key_openssh
  database_url       = module.database.service_uri
  server_public_ip   = module.server.public_ip
}
