resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"

  tags = {
    Name = "vpc-${var.tag_name}"
  }
}

# data "template_file" "build" {
#   template = "${file("${path.module}/file/build.json")}"

#   vars = {
#     vpc_id    = "${aws_vpc.main.id}"
#     subnet_id = "${aws_subnet.subnet-main.id}"
#   }
# }

# resource "null_resource" "create-ami-vault" {
#   provisioner "local-exec" {
#     command     = "packer build build.json"
#     interpreter = ["/bin/bash", "-c"]
#   }

#   depends_on = ["aws_vpc.main"]
# }

resource "aws_subnet" "subnet-main" {
  availability_zone       = "${var.availability_zone}"
  cidr_block              = "${var.subnet_cidr_block}"
  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
  vpc_id                  = "${aws_vpc.main.id}"

  tags = {
    Name = "subnet-${var.tag_name}"
  }
}

resource "aws_route_table" "rtb-main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "rtb-${var.tag_name}"
  }
}

resource "aws_network_interface" "multi-ip" {
  subnet_id   = "${aws_subnet.subnet-main.id}"
  private_ips = ["10.0.1.5"]
}

resource "aws_eip" "main" {
  vpc                       = true
  network_interface         = "${aws_network_interface.multi-ip.id}"
  associate_with_private_ip = "10.0.1.5"
}
