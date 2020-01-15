provider "aws" {
  region = "us-east-1"
}

module "vpc-main" {
  source                  = "./modules/network"
  availability_zone       = "${var.availability_zone}"
  destination_cidr_block  = "${var.destination_cidr_block}"
  enable_dns_hostnames    = "${var.enable_dns_hostnames}"
  enable_dns_support      = "${var.enable_dns_support}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
  subnet_cidr_block       = "${var.subnet_cidr}"
  vpc_cidr_block          = "${var.vpc_cidr_block}"
  tag_name                = "${var.name}"
}
