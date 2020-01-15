output "vpc_id" {
  value = "${module.vpc-main.vpc_id}"
}

output "subnet_id" {
  value = "${module.vpc-main.subnet_id}"
}
