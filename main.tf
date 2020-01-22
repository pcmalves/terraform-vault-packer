provider "aws" {
  region = "us-east-1"
}

module "vault-vpc" {
  source                  = "./modules/network"
  availability_zone       = "${var.availability_zone}"
  destination_cidr_block  = "${var.destination_cidr_block}"
  enable_dns_hostnames    = "${var.enable_dns_hostnames}"
  enable_dns_support      = "${var.enable_dns_support}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
  subnet_cidr_block       = "${var.subnet_cidr}"
  tag_name                = "${var.name}"
  vpc_cidr_block          = "${var.vpc_cidr_block}"
}

module "vault-instance" {
  source                      = "./modules/instance"
  ami                         = "${var.ami}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  private_ip                  = "${var.private_ip}"
  root_block_device           = "${var.root_block_device}"
  source_dest_check           = "${var.source_dest_check}"
  subnet_id                   = "${module.vault-vpc.subnet_id}"
  vpc_security_group_ids      = "${aws_security_group.sg_vault_server.id}"
}

data "http" "my-ip-address" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "sg_vault_server" {
  vpc_id = "${module.vault-vpc.vpc_id}"

  ingress {
    description = "ssh access to my ip"
    cidr_blocks = ["${chomp(data.http.my-ip-address.body)}/32"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  ingress {
    description = "http access for everyone"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    Name = "sg-${var.name}"
  }
}
