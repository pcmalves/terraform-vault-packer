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

# apt-get update
# apt-get -y install python-pip
# sudo -H -u ubuntu bash -c "pip install ansible-tower-cli"
# cd /home/ubuntu &&
# echo "host: awx.quero.space" >> .tower_cli.cfg &&
# echo "password: 1n@!7CbfDx1aYRmf" >> .tower_cli.cfg && 
# echo "username: grao_vizir" >> .tower_cli.cfg &&
# chown ubuntu.ubuntu .tower_cli.cfg &&
# chmod 600 .tower_cli.cfg &&
# echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKxRtusT4l04oWYsriSiLEy8PlNYZXVUUfhEtT38Yj3YbB0DuF3alQYPTjn9RXgZ8TDrk0ntkcja+Gn4nQHsM3M2H6QG+jfw0Rr+HlRR0HnsCSOL/GDwjKm14SFahaDndGa63mDPhpJPIDB2zKAeo5t0n13guI1euDWAUHwI3cxzvCU5GI6Uv8xwDO9cJJxBDIpHYAuKeO5bfar4/gKikcWCLGxCBryjf6RWezSIVru/M2l08KexCIg0qF+3wVXXCXYJOWeMoTdShB3oEnwR+FYjIMolGnPhSGOO07OnyW1GVHB5BawqaS0DLGnj8alMGV8rNgIm06HP0XarFljrvt awx@awx-server" >> /home/ubuntu/.ssh/authorized_keys &&
# ADDRESS_INSTANCE=$(hostname -I | cut -f1 -d' ') &&
# INVENTORY_NAME='instance' &&
# sudo -H -u ubuntu bash -c "/home/ubuntu/.local/bin/tower-cli host create --name=$ADDRESS_INSTANCE --inventory=$INVENTORY_NAME"


# aws ec2 describe-instances --region us-east-1 --filter | grep Code | cut -d ':' -f 2 | grep 48 | cut -d ',' -f1
# aws ec2 describe-instances --filter Name=private-ip-address,Values=10.10.97.37 | grep -A 20 NetworkInterfaces | grep -oP '(?<=PrivateIpAddress": ").*(?=")'
# tower-cli inventory list | grep 15 | cut -f1 -d ' '

