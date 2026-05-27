resource "tls_private_key" "deploy" {
  algorithm = "ED25519"
}

resource "github_repository_environment" "env" {
  for_each    = local.environments
  repository  = var.github_repository
  environment = each.key
}

resource "github_actions_environment_secret" "ssh_private_key" {
  for_each    = local.environments
  repository  = var.github_repository
  environment = github_repository_environment.env[each.key].environment
  secret_name = "SSH_PRIVATE_KEY"
  value       = tls_private_key.deploy.private_key_openssh
}

resource "github_actions_environment_variable" "deploy_host" {
  for_each      = local.environments
  repository    = var.github_repository
  environment   = github_repository_environment.env[each.key].environment
  variable_name = "DEPLOY_HOST"
  value         = upcloud_server.app[each.key].network_interface[0].ip_address
}

resource "github_actions_environment_secret" "database_url" {
  for_each    = local.environments
  repository  = var.github_repository
  environment = github_repository_environment.env[each.key].environment
  secret_name = "DATABASE_URL"
  value       = upcloud_managed_database_postgresql.main[each.key].service_uri
}

resource "github_actions_secret" "upcloud_key" {
  repository  = var.github_repository
  secret_name = "UPCLOUD_KEY"
  value       = ""

  lifecycle {
    ignore_changes  = [value]
    prevent_destroy = true
  }
}

resource "github_actions_secret" "terraform_cloud_key" {
  repository  = var.github_repository
  secret_name = "TERRAFORM_CLOUD_KEY"
  value       = ""

  lifecycle {
    ignore_changes  = [value]
    prevent_destroy = true
  }
}
