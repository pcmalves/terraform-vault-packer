provider "aws" {
  region = "us-west-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQpaupYGrGt3hhjG5ZmDOLXbCAWMXBsYFbqSz8pMRoTdeLNTPNtA/DE6qkav9L6XLm8jk5ZI7u8QWR4Ya+QUQRIzrXNgsArMkX6fCYBvQw05rYH3z1yRhfPXEVT61b0mOOQXiL8httxNZuN0xzGmnxjL9H0Cm3tJePc5xcEyh4r2dwfc4JVrmoSK2jWc7Q0xpuXjVtnW05EVkOgAmow3aHQPoyqMZNILr/TXkZFQHhDEPWpcrrmGSJ0kA8ogikLFJf4f5MJtOG3c6BTnqsy4VLY5OsidGNWS8LEmxqrY2cVolE7YdmkGtqmnT4ItvmtiUM6dpf paulo@example"
}

data "aws_ami" "base-image" {
  most_recent = true
  owners      = ["099874797698"]

  filter {
    name   = "name"
    values = ["image-base-vault-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  ami                    = "${data.aws_ami.base-image.id}"
  instance_type          = "t2.micro"
  key_name               = "deployer-key"
  subnet_id              = "${aws_subnet.subnet-public-vault-server.id}"
  vpc_security_group_ids = ["${aws_security_group.sg_vault_server.id}"]

  depends_on = [
    "aws_internet_gateway.igw-vault-server",
    "aws_route.route-public-vault-server",
    "aws_route_table.rtb-public-vault-server",
    "aws_route_table_association.public",
    "aws_subnet.subnet-public-vault-server",
    "aws_vpc.vpc-main",
  ]

  tags = {
    Name = "ec2-${var.tag_name}"
  }
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "sg_vault_server" {
  vpc_id = "${aws_vpc.vpc-main.id}"

  ingress {
    description = "Access instance SSH"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  ingress {
    description = "Access home vault server"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8200
    protocol    = "tcp"
    to_port     = 8200
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = {
    Name = "sg-vault-server"
  }
}

resource "aws_vpc" "vpc-main" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags = {
    Name = "vpc-${var.tag_name}"
  }
}

//---------------
//Public Subnet
//---------------
resource "aws_internet_gateway" "igw-vault-server" {
  vpc_id = "${aws_vpc.vpc-main.id}"

  tags = {
    Name = "igw-${var.tag_name}"
  }
}

resource "aws_route_table" "rtb-public-vault-server" {
  vpc_id = "${aws_vpc.vpc-main.id}"

  tags = {
    Name = "rtb-${var.tag_name}"
  }
}

resource "aws_route" "route-public-vault-server" {
  route_table_id         = "${aws_route_table.rtb-public-vault-server.id}"
  destination_cidr_block = "${var.destination_cidr_block}"
  gateway_id             = "${aws_internet_gateway.igw-vault-server.id}"
}

resource "aws_subnet" "subnet-public-vault-server" {
  vpc_id                  = "${aws_vpc.vpc-main.id}"
  cidr_block              = "${var.subnet-public}"
  availability_zone       = "${var.availability_zone}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"

  provisioner "local-exec" {
    command = "cp -r ./create_image.tpl create_image.json"
  }

  provisioner "local-exec" {
    command = "sed -i 's:VPC_ID:${aws_vpc.vpc-main.id}:g' ./create_image.json"
  }

  provisioner "local-exec" {
    command = "sed -i 's:SUBNET_ID:${aws_subnet.subnet-public-vault-server.id}:g' ./create_image.json"
  }

  tags = {
    Name = "subnet-public-${var.tag_name}"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = "${aws_subnet.subnet-public-vault-server.id}"
  route_table_id = "${aws_route_table.rtb-public-vault-server.id}"
}

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

