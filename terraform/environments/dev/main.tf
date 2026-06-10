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
  backend "s3" {
    bucket = "terraform-state"
    key    = "dev/terraform.tfstate"
    region = "europe-1"
    endpoints = {
      s3  = "https://hsu3i.upcloudobjects.com"
      iam = "https://hsu3i.upcloudobjects.com:4443/iam"
      sts = "https://hsu3i.upcloudobjects.com:4443/sts"
    }
    skip_requesting_account_id  = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
    use_path_style              = true
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
  environment       = "dev"
  zone              = var.zone
  ssh_public_keys   = var.ssh_public_keys
  github_repository = var.github_repository
}
