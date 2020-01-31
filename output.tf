output "vpc_id" {
  value = "${aws_vpc.vpc-main.id}"
}

output "subnet_id" {
  value = "${aws_subnet.subnet-public-vault-server.id}"
}
