provider "aws" {
  region = "us-west-1"
}

data "terraform_remote_state" "remote-state-project" {
  backend = "local"

  config {
    path = "../terraform.tfstate"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQpaupYGrGt3hhjG5ZmDOLXbCAWMXBsYFbqSz8pMRoTdeLNTPNtA/DE6qkav9L6XLm8jk5ZI7u8QWR4Ya+QUQRIzrXNgsArMkX6fCYBvQw05rYH3z1yRhfPXEVT61b0mOOQXiL8httxNZuN0xzGmnxjL9H0Cm3tJePc5xcEyh4r2dwfc4JVrmoSK2jWc7Q0xpuXjVtnW05EVkOgAmow3aHQPoyqMZNILr/TXkZFQHhDEPWpcrrmGSJ0kA8ogikLFJf4f5MJtOG3c6BTnqsy4VLY5OsidGNWS8LEmxqrY2cVolE7YdmkGtqmnT4ItvmtiUM6dpfEqOy4RRcGOplCD9l paulo@qbnotebook"
}

data "aws_ami" "base-image" {
  most_recent = true
  owners      = ["725582217686"]

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
  subnet_id              = "${data.terraform_remote_state.remote-state-project.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.sg_vault_server.id}"]

  tags = {
    Name = "ec2-${var.tag_name}"
  }
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "sg_vault_server" {
  vpc_id = "${data.terraform_remote_state.remote-state-project.vpc_id}"

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
