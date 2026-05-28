variable "environment" {
  type = string
}

variable "zone" {
  type = string
}

variable "private_network_id" {
  type = string
}

variable "deploy_public_key" {
  type = string
}

variable "ssh_public_keys" {
  type = list(string)
}

variable "plan" {
  type    = string
  default = "1xCPU-1GB"
}

variable "storage_template" {
  type    = string
  default = "Ubuntu Server 24.04 LTS (Noble Numbat)"
}

variable "storage_size" {
  type    = number
  default = 10
}
