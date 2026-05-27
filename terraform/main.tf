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
      tags = ["feedback-tool"]
    }
  }

}

provider "upcloud" {
  token = var.upcloud_token
}

provider "github" {
  token = var.github_token
  owner = "angelsnl"
}

locals {
  environment = trimprefix(terraform.workspace, "feedback-tool-")
}

