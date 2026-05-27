resource "tls_private_key" "deploy" {
  algorithm = "ED25519"
}

resource "github_repository_environment" "env" {
  repository  = var.github_repository
  environment = local.environment
}

resource "github_actions_environment_secret" "ssh_private_key" {
  repository  = var.github_repository
  environment = github_repository_environment.env.environment
  secret_name = "SSH_PRIVATE_KEY"
  value       = tls_private_key.deploy.private_key_openssh
}

resource "github_actions_environment_variable" "deploy_host" {
  repository    = var.github_repository
  environment   = github_repository_environment.env.environment
  variable_name = "DEPLOY_HOST"
  value         = upcloud_server.app.network_interface[0].ip_address
}

resource "github_actions_environment_secret" "database_url" {
  repository  = var.github_repository
  environment = github_repository_environment.env.environment
  secret_name = "DATABASE_URL"
  value       = upcloud_managed_database_postgresql.main.service_uri
}
