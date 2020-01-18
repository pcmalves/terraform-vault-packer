variable "ami" {}
variable "associate_public_ip_address" {}
variable "iam_instance_profile" {}
variable "instance_type" {}
variable "key_name" {}
variable "private_ip" {}

variable "root_block_device" {
  type = "list"
}

variable "source_dest_check" {}
variable "subnet_id" {}
variable "user_data" {}
variable "vpc_security_group_ids" {}
