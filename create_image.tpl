{
    "variables": {
      "aws_access_key": "",
      "aws_secret_key": "",
      "vpc_id": "",
      "subnet_id": "",
      "region": "us-west-1"
    },
    "builders": [{
      "type": "amazon-ebs",
      "access_key": "{{user `aws_access_key`}}",
      "secret_key": "{{user `aws_secret_key`}}",
      "region": "{{user `region`}}",
      "source_ami_filter": {
        "filters": {
          "virtualization-type": "hvm",
          "name": "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*",
          "root-device-type": "ebs"
        },
        "owners": ["099720109477"],
        "most_recent": true
      },
      "instance_type": "t2.micro",
      "ssh_username": "ubuntu",
      "ami_name": "image-base-vault-{{timestamp}}",
      "vpc_id": "VPC_ID",
      "subnet_id": "SUBNET_ID",
      "tags": {
        "Name": "vault-image"
      }
    }],
    "provisioners": [{
        "type": "shell",
        "scripts": ["packer/config.sh"]
      }]
  }