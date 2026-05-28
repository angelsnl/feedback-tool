variable "environment" {
  type = string
}

variable "github_repository" {
  type = string
}

variable "deploy_private_key" {
  type      = string
  sensitive = true
}

variable "database_url" {
  type      = string
  sensitive = true
}

variable "server_public_ip" {
  type = string
}
