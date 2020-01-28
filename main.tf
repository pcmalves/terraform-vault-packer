provider "aws" {
  region = "us-east-1"
}

# resource "aws_instance" "web" {
#   ami                    = "ami-04b9e92b5572fa0d1"
#   instance_type          = "t2.micro"
#   key_name               = "infra-system-deploy"
#   subnet_id              = "${aws_subnet.subnet-public-vault-server.id}"
#   vpc_security_group_ids = ["${aws_security_group.sg_vault_server.id}"]
#   user_data              = "${file("./packer/config.sh")}"

#   tags = {
#     Name = "Teste-User-Data"
#   }
# }

# resource "aws_security_group" "sg_vault_server" {
#   vpc_id = "${aws_vpc.vpc-main.id}"

#   ingress {
#     description = "ssh access to my ip"
#     cidr_blocks = ["0.0.0.0/0"]
#     from_port   = 22
#     protocol    = "tcp"
#     to_port     = 22
#   }

#   egress {
#     cidr_blocks = ["0.0.0.0/0"]
#     from_port   = 0
#     protocol    = "-1"
#     to_port     = 0
#   }

#   tags = {
#     Name = "sg-vault-server"
#   }
# }

# resource "aws_vpc" "vpc-main" {
#   cidr_block           = "${var.vpc_cidr_block}"
#   enable_dns_hostnames = "${var.enable_dns_hostnames}"
#   enable_dns_support   = "${var.enable_dns_support}"

#   tags = {
#     Name = "vpc-${var.tag_name}"
#   }
# }

# //---------------
# //Public Subnet
# //---------------
# resource "aws_internet_gateway" "igw-vault-server" {
#   vpc_id = "${aws_vpc.vpc-main.id}"

#   tags = {
#     Name = "igw-${var.tag_name}"
#   }
# }

# resource "aws_route_table" "rtb-public-vault-server" {
#   vpc_id = "${aws_vpc.vpc-main.id}"

#   tags = {
#     Name = "rtb-${var.tag_name}"
#   }
# }

# resource "aws_route" "route-public-vault-server" {
#   route_table_id         = "${aws_route_table.rtb-public-vault-server.id}"
#   destination_cidr_block = "${var.destination_cidr_block}"
#   gateway_id             = "${aws_internet_gateway.igw-vault-server.id}"
# }

# resource "aws_subnet" "subnet-public-vault-server" {
#   vpc_id                  = "${aws_vpc.vpc-main.id}"
#   cidr_block              = "${var.subnet-public}"
#   availability_zone       = "${var.availability_zone}"
#   map_public_ip_on_launch = "${var.map_public_ip_on_launch}"

#   tags = {
#     Name = "subnet-public-${var.tag_name}"
#   }
# }

# resource "aws_route_table_association" "public" {
#   subnet_id      = "${aws_subnet.subnet-public-vault-server.id}"
#   route_table_id = "${aws_route_table.rtb-public-vault-server.id}"
# }

# //--------------
# //Private Subnet
# //--------------
# resource "aws_eip" "ipwan" {
#   depends_on = ["aws_internet_gateway.igw-vault-server"]
#   vpc        = true

#   tags = {
#     Name = "eip-${var.tag_name}"
#   }
# }

# resource "aws_nat_gateway" "nat-gw-subnet-private" {
#   allocation_id = "${aws_eip.ipwan.id}"
#   subnet_id     = "${aws_subnet.subnet-public-vault-server.id}"
#   depends_on    = ["aws_internet_gateway.igw-vault-server"]

#   tags = {
#     Name = "nat-gw-${var.tag_name}"
#   }
# }

# resource "aws_route_table" "rtb-private-vault-server" {
#   vpc_id = "${aws_vpc.vpc-main.id}"

#   tags = {
#     Name = "rtb-private-${var.tag_name}"
#   }
# }

# resource "aws_subnet" "subnet-private-vault-server" {
#   vpc_id            = "${aws_vpc.vpc-main.id}"
#   cidr_block        = "${var.subnet-private}"
#   availability_zone = "${var.availability_zone}"

#   tags = {
#     Name = "subnet-private-${var.tag_name}"
#   }
# }

# resource "aws_route_table_association" "rtb-private-vault-server" {
#   subnet_id      = "${aws_subnet.subnet-private-vault-server.id}"
#   route_table_id = "${aws_route_table.rtb-private-vault-server.id}"
# }

# resource "aws_route" "private_nat_gateway" {
#   route_table_id         = "${aws_route_table.rtb-private-vault-server.id}"
#   destination_cidr_block = "${var.destination_cidr_block}"
#   nat_gateway_id         = "${aws_nat_gateway.nat-gw-subnet-private.id}"
#   depends_on             = ["aws_nat_gateway.nat-gw-subnet-private"]
# }
