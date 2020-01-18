variable "ami" {
  default = "ami-04b9e92b5572fa0d1"
}

variable "associate_public_ip_address" {
  default = true
}

variable "iam_instance_profile" {
  default = ""
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  default = "infra-system-deploy"
}

variable "private_ip" {
  default = ""
}

variable "root_block_device" {
  default = [{
    volume_type           = "gp2"
    volume_size           = "30"
    delete_on_termination = "true"
  }]
}

variable "source_dest_check" {
  default = ""
}

variable "availability_zone" {
  default = "us-east-1b"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "destination_cidr_block" {
  default = "0.0.0.0/0"
}

variable "enable_dns_support" {
  default = true
}

variable "enable_dns_hostnames" {
  default = true
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "name" {
  default = "vault-server"
}

variable "map_public_ip_on_launch" {
  default = true
}
