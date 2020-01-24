#!/bin/bash

# rm -rf /var/lib/apt/lists/*
DEBIAN_FRONTEND=noninteractive 
sudo apt-get update && sudo apt-get -y install curl 
sudo apt-get -y install unzip 
# curl -sO https://releases.hashicorp.com/vault/1.3.2/vault_1.3.2_linux_amd64.zip
# sudo mv vault /usr/local/bin/
# vault -autocomplete-install && complete -C /usr/local/bin/vault vault