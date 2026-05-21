variable "upcloud_username" {
  description = "UpCloud API username"
  type        = string
  sensitive   = true
}

variable "upcloud_password" {
  description = "UpCloud API password"
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
  default     = "form-app"
}

variable "zone" {
  description = "UpCloud zone"
  type        = string
  default     = "de-fra1"
}

variable "ssh_public_key" {
  description = "SSH public key for server access"
  type        = string
}

variable "admin_ip" {
  description = "Admin IP address allowed SSH access"
  type        = string
}

variable "db_allowed_ips" {
  description = "CIDRs allowed to connect to the managed database"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
