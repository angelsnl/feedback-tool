variable "zone" {
  description = "UpCloud zone"
  type        = string
  default     = "fi-hel2"
}

variable "upcloud_token" {
  type = string
  sensitive = true
}
