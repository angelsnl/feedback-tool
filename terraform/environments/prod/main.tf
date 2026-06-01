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
      name = "feedback-tool-prod"
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

module "environment" {
  source            = "../../modules/environment"
  environment       = "prod"
  zone              = var.zone
  ssh_public_keys   = var.ssh_public_keys
  github_repository = var.github_repository
}
