module "instance" {
  source                 = "git::https://github.com/pcmalves/tf-module-instance.git"
  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key_name}"
  name_instance          = "${var.name_instance}"
  root_block_device      = "${var.root_block_device}"
  subnet_id              = "${module.vpc-main.subnet_id}"
  vpc_security_group_ids = "${aws_security_group.sg_awx_server.id}"

  tags = {
    Name = "${var.tag_name}"
  }
}
