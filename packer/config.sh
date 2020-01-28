#!/bin/bash

sudo apt-get update && sudo apt-get -y install curl unzip
curl -sO https://releases.hashicorp.com/vault/1.3.1/vault_1.3.1_linux_amd64.zip
unzip vault_1.3.1_linux_amd64.zip
sudo mv vault /usr/local/bin/
vault -autocomplete-install
complete -C /usr/local/bin/vault vault
sudo mkdir /etc/vault
sudo mkdir -p /var/lib/vault/data
sudo useradd --system --home /etc/vault --shell /bin/false vault
sudo chown -R vault:vault /etc/vault /var/lib/vault/

