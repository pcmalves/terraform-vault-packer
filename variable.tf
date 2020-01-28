variable "tag_name" {
  default = "vault-server"
}

variable "enable_dns_support" {
  default = true
}

variable "enable_dns_hostnames" {
  default = true
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "destination_cidr_block" {
  default = "0.0.0.0/0"
}

variable "subnet-public" {
  default = "10.0.0.0/24"
}

variable "subnet-private" {
  default = "10.0.1.0/24"
}

variable "availability_zone" {
  default = "us-east-1c"
}

variable "map_public_ip_on_launch" {
  default = true
}
