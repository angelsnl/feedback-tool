variable "environment" {
  type = string
}

variable "zone" {
  type = string
}

variable "cidr" {
  type    = string
  default = "10.0.0.0/24"
}
