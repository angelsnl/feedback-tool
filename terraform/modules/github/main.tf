terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

resource "github_repository_environment" "env" {
  repository  = var.github_repository
  environment = var.environment
}

resource "github_actions_environment_secret" "ssh_private_key" {
  repository  = var.github_repository
  environment = github_repository_environment.env.environment
  secret_name = "SSH_PRIVATE_KEY"
  value       = var.deploy_private_key
}

resource "github_actions_environment_variable" "deploy_host" {
  repository    = var.github_repository
  environment   = github_repository_environment.env.environment
  variable_name = "DEPLOY_HOST"
  value         = var.server_public_ip
}

resource "github_actions_environment_secret" "database_url" {
  repository  = var.github_repository
  environment = github_repository_environment.env.environment
  secret_name = "DATABASE_URL"
  value       = var.database_url
}
