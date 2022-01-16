#!/bin/bash
NODE_IP_ADDR=
ADDRESS_FROM_NODE=

apt update
apt install libc6 -y
rm -rf /miner444/*
mkdir /miner444
sudo wget -qO /miner444/kaspa-miner.tgz https://github.com/tmrlvi/kaspa-miner/releases/download/v0.2.1-GPU-0.2/kaspa-miner-v0.2.1-GPU-0.2-linux-gnu-amd64.tgz
tar zxvf /miner444/kaspa-miner.tgz  -C /miner444
mv /miner444/kaspa-miner-v0.2.1-GPU-0.2-linux-gnu-amd64/lib* /miner444/
mv /miner444/kaspa-miner-v0.2.1-GPU-0.2-linux-gnu-amd64/kaspa-miner-v0.2.1-GPU-0.2-linux-gnu-amd64 /miner444/kaspa-miner
chmod +x /miner444/kaspa-miner

sudo tee /etc/systemd/system/miner444.service > /dev/null <<EOF
[Unit]
Description=kaspa miner
After=rc-local.service

[Service]
RestartSec=5
Restart=always
#RuntimeMaxSec=3600
WorkingDirectory=/miner444
TimeoutSec=180
ExecStart=/miner444/kaspa-miner --kaspad-address $NODE_IP_ADDR --mining-address $ADDRESS_FROM_NODE -t 0

[Install]
WantedBy=multi-user.target
Alias=miner444.service
EOF

sudo systemctl daemon-reload
sudo systemctl enable miner444
sudo systemctl restart miner444

journalctl -f -u miner444
