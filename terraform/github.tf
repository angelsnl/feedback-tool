resource "github_actions_secret" "database_url" {
  for_each        = local.environments
  repository      = var.github_repository
  secret_name     = "DATABASE_URL_${upper(each.key)}"
  plaintext_value = upcloud_managed_database_postgresql.main[each.key].service_uri
}
