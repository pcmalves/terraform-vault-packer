variable "availability_zone" {
  default = "us-east-1c"
}

variable "destination_cidr_block" {
  default = "0.0.0.0/0"
}

variable "enable_dns_hostnames" {
  default = true
}

variable "enable_dns_support" {
  default = true
}

variable "map_public_ip_on_launch" {
  default = true
}

variable "name" {
  default = "vault-server"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}
