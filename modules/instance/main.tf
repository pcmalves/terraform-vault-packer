resource "aws_instance" "main" {
  ami                         = "${var.ami}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  private_ip                  = "${var.private_ip}"
  root_block_device           = "${var.root_block_device}"
  source_dest_check           = "${var.source_dest_check}"
  subnet_id                   = "${var.subnet_id}"
  user_data                   = "${var.user_data}"
  vpc_security_group_ids      = ["${var.vpc_security_group_ids}"]
}
