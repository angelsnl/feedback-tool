variable "environment" {
  type = string
}

variable "zone" {
  type = string
}

variable "ssh_public_keys" {
  type = list(string)
}

variable "github_repository" {
  type = string
}
