variable "environment" {
  type = string
}

variable "zone" {
  type = string
}

variable "private_network_id" {
  type = string
}

variable "private_network_cidr" {
  type = string
}

variable "plan" {
  type    = string
  default = "1x1xCPU-2GB-25GB"
}
