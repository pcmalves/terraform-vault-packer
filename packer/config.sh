#!/bin/bash

sleep 10
sudo apt-get update && sudo apt-get -y install curl zip unzip
curl -sO https://releases.hashicorp.com/vault/1.3.1/vault_1.3.1_linux_amd64.zip
unzip vault_1.3.1_linux_amd64.zip
sudo mv vault /usr/local/bin/
vault -autocomplete-install
complete -C /usr/local/bin/vault vault
sudo mkdir /etc/vault
sudo mkdir -p /var/lib/vault/data
sudo useradd --system --home /etc/vault --shell /bin/false vault
sudo chown -R vault:vault /etc/vault /var/lib/vault/

cat <<EOF | sudo tee /etc/systemd/system/vault.service
[Unit]
Description="HashiCorp Vault - A tool for managing secrets"
Documentation=https://www.vaultproject.io/docs/
Requires=network-online.target
After=network-online.target
ConditionFileNotEmpty=/etc/vault/config.hcl

[Service]
User=vault
Group=vault
ProtectSystem=full
ProtectHome=read-only
PrivateTmp=yes
PrivateDevices=yes
SecureBits=keep-caps
AmbientCapabilities=CAP_IPC_LOCK
NoNewPrivileges=yes
ExecStart=/usr/local/bin/vault server -config=/etc/vault/config.hcl
ExecReload=/bin/kill --signal HUP 
KillMode=process
KillSignal=SIGINT
Restart=on-failure
RestartSec=5
TimeoutStopSec=30
StartLimitBurst=3
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF

sudo touch /etc/vault/config.hcl

cat <<EOF | sudo tee /etc/vault/config.hcl
disable_cache = true

disable_mlock = true

ui = true

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_disable = 1
}

storage "file" {
  path = "/var/lib/vault/data"
}

api_addr = "http://0.0.0.0:8200"

max_lease_ttl = "10h"

default_lease_ttl = "10h"

cluster_name = "vault"

raw_storage_endpoint = true

disable_sealwrap = true

disable_printable_check = true
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now vault
echo "export VAULT_ADDR=http://0.0.0.0:8200" >> ~/.bashrc
source ~/.bashrc
sudo rm -rf  /var/lib/vault/data/*