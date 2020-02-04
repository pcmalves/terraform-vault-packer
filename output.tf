output "vpc-id" {
  value = "${aws_vpc.vpc-main.id}"
}

output "public-subnet-id" {
  value = "${aws_subnet.subnet-public-vault-server.id}"
}

output "private-subnet-id" {
  value = "${aws_subnet.subnet-private-vault-server.id}"
}
