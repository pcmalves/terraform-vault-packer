variable "ami" {}
variable "instance_type" {}
variable "key_name" {}
variable "name_instance" {}
variable "tag_name" {}

variable "root_block_device" {
  type = "list"
}

variable "subnet_id" {}
variable "vpc_security_group_ids" {}
