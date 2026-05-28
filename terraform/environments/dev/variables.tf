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
  type    = string
  default = "feedback-tool"
}

variable "github_owner" {
  type    = string
  default = "angelsnl"
}

variable "ssh_public_keys" {
  description = "SSH public keys for server access"
  type        = list(string)
  default = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDGxqyhR02yclevvbcgeWNIzpdwZX/OORGkuoiTvxq/P jook@maxos-work",
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOXFkMEYw69Gp/2flL0XgvGZUJAZ7dM3baKDBPWWzNLm vike@macbook-work",
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINUmD1Ik72f9W54EV9x0Up6Q8RWJwSTmoXqcxpSr9MbF abds@macbook",
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAOHerEf2NP5ozdtcYxMa/mEwVn55acVa2mndb+xlOnw phag@macbook"
  ]
}
