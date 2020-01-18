resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags = {
    Name = "vpc-${var.tag_name}"
  }
}

resource "aws_subnet" "subnet-main" {
  availability_zone       = "${var.availability_zone}"
  cidr_block              = "${var.subnet_cidr_block}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
  vpc_id                  = "${aws_vpc.main.id}"

  tags = {
    Name = "subnet-${var.tag_name}"
  }
}

resource "aws_internet_gateway" "igw-main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "igw-${var.tag_name}"
  }
}

resource "aws_route_table" "rtb-main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "rtb-${var.tag_name}"
  }
}

resource "aws_route" "internet-access-main" {
  destination_cidr_block = "${var.destination_cidr_block}"
  gateway_id             = "${aws_internet_gateway.igw-main.id}"
  route_table_id         = "${aws_route_table.rtb-main.id}"
}

resource "aws_route_table_association" "vpc-association" {
  route_table_id = "${aws_route_table.rtb-main.id}"
  subnet_id      = "${aws_subnet.subnet-main.id}"
}
