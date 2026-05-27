variable "zone" {
  description = "UpCloud zone"
  type        = string
  default     = "fi-hel2"
}

variable "upcloud_token" {
  type      = string
  sensitive = true
}

variable "github_token" {
  description = "GitHub personal access token with repo secrets permission"
  type        = string
  sensitive   = true
}

variable "github_repository" {
  description = "GitHub repository in owner/name format"
  type        = string
  default     = "angelsnl/feedback-tool"
}
