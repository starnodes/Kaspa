apt update
apt-get install zip unzip -y
cd
sudo wget -qO $HOME/kaspad-linux.zip https://github.com/kaspanet/kaspad/releases/download/v0.11.8/kaspad-v0.11.8-linux.zip
unzip $HOME/kaspad-linux.zip -d $HOME/.kaspad

sudo tee /etc/systemd/system/kaspad.service > /dev/null <<EOF
[Unit]
Description=alephium
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

journalctl -f -u kaspad
