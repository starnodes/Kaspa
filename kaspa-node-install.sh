#!/bin/bash

apt update
apt-get install zip unzip -y
cd
sudo systemctl stop kaspad
sudo systemctl stop kaspad-wallet
rm -f $HOME/.kaspad/bin/*
sudo wget -qO $HOME/kaspad-linux.zip https://github.com/kaspanet/kaspad/releases/download/v0.11.9/kaspad-v0.11.9-linux.zip
unzip $HOME/kaspad-linux.zip -d $HOME/.kaspad

sudo tee /etc/systemd/system/kaspad.service > /dev/null <<EOF
[Unit]
Description=kaspa
[Service]
User=$USER
Type=simple
ExecStart=$HOME/.kaspad/bin/kaspad --utxoindex
Restart=always
RestartSec=100
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable kaspad
sudo systemctl restart kaspad

sudo tee /etc/systemd/system/kaspad-wallet.service > /dev/null <<EOF
[Unit]
Description=kaspa-wallet
[Service]
User=$USER
Type=simple
ExecStart=$HOME/.kaspad/bin/kaspawallet start-daemon
Restart=always
RestartSec=100
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable kaspad-wallet
sudo systemctl restart kaspad-wallet

echo 'use for wallet create: $HOME/.kaspad/bin/kaspawallet create'
echo 'use for address create: $HOME/.kaspad/bin/kaspawallet new-address'
