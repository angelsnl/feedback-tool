variable "environment" {
  type = string
}

variable "zone" {
  type = string
}

variable "pg_plan" {
  type    = string
  default = "1x1xCPU-1GB-10GB"
}

variable "ssh_public_keys" {
  type = list(string)
}

variable "github_repository" {
  type = string
}
