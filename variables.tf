variable "tag_name" {
  default = "vault-server"
}

variable "enable_dns_support" {
  default = true
}

variable "enable_dns_hostnames" {
  default = true
}

variable "vpc_cidr_block" {
  default = "172.16.0.0/16"
}

variable "destination_cidr_block" {
  default = "0.0.0.0/0"
}

variable "subnet-public" {
  default = ["172.16.3.0/24", "172.16.0.0/24"]
}

variable "subnet-private" {
  default = ["172.16.2.0/24", "172.16.1.0/24"]
}

variable "availability_zone" {
  default = ["us-west-1a", "us-west-1c"]
}

variable "map_public_ip_on_launch" {
  default = true
}
