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
  }
  required_version = ">= 1.3"
  cloud {
    organization = "pepes-angels-test"
    workspaces {
      name = "upcloud-test"
    }
  }

}

provider "upcloud" {
  token = var.upcloud_token
}

provider "github" {
  token = var.github_token
}

locals {
  environments = toset(["dev"])
}
