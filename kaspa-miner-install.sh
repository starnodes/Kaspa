#!/bin/bash

apt update
apt install libc6 -y
mkdir /miner
wget -P /miner https://github.com/elichai/kaspa-miner/releases/download/v0.2.0/kaspa-miner-v0.2.0-linux-amd64
chmod +x /miner/kaspa-miner-v0.2.0-linux-amd64

sudo tee /etc/systemd/system/miner444.service > /dev/null <<EOF
[Unit]
Description=kaspa miner
After=rc-local.service

[Service]
RestartSec=5
Restart=always
#RuntimeMaxSec=3600
WorkingDirectory=/miner
TimeoutSec=180
ExecStart=/miner/kaspa-miner-v0.2.0-linux-amd64 --kaspad-address NODE_IP_ADDR --mining-address kaspa:ADDRESS_FROM_NODE

[Install]
WantedBy=multi-user.target
Alias=miner444.service
EOF

sudo systemctl daemon-reload
sudo systemctl enable miner444
sudo systemctl restart miner444

journalctl -f -u miner444
