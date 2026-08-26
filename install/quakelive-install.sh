#!/usr/bin/env bash

# Copyright (c) 2021-2026 community-scripts.org
# Author: RainingDaemons
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://store.steampowered.com/app/282440 | Github: https://github.com/RainingDaemons/QuakeLiveServer

source /dev/stdin <<<"$FUNCTIONS_FILE_PATH"
color
verb_ip6
catch_errors
setting_up_container
network_check
update_os

msg_info "Installing Dependencies"
$STD dpkg --add-architecture i386
$STD apt-get update
$STD apt-get install -y ca-certificates wget git python3 python3-pip lib32gcc-s1 lib32stdc++6 lib32z1 ufw
$STD pip3 install --break-system-packages pyzmq
msg_ok "Installed Dependencies"

msg_info "Setting up Firewall"
$STD ufw enable
$STD ufw allow 27960/udp
$STD ufw allow 27960/tcp
$STD ufw allow 28960/tcp
$STD ufw allow 28960/udp
msg_ok "Set up Firewall"

msg_info "Creating steam user"
useradd -m -s /bin/bash steam
msg_ok "Created steam user"

msg_info "Installing SteamCMD"
$STD wget -q -O /home/steam/steamcmd_linux.tar.gz https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
$STD tar -xzf /home/steam/steamcmd_linux.tar.gz -C /home/steam
$STD rm /home/steam/steamcmd_linux.tar.gz
chown -R steam:steam /home/steam
msg_ok "Installed SteamCMD"

msg_info "Installing Quake Live Dedicated Server"
su - steam -c "cd /home/steam && ./steamcmd.sh +force_install_dir /home/steam/quakelive/qlds/ +login anonymous +app_update 349090 +quit"
msg_ok "Installed Quake Live Dedicated Server"

msg_info "Setting up Quake Live Server"
mkdir -p /home/steam/quakelive
$STD git clone --depth 1 -b main https://github.com/RainingDaemons/QuakeLiveServer.git /tmp/QuakeLiveServer
cp /tmp/QuakeLiveServer/config.toml /home/steam/quakelive/config.toml
cp /tmp/QuakeLiveServer/run_server.sh /home/steam/quakelive/run_server.sh
cp /tmp/QuakeLiveServer/update_server.sh /home/steam/quakelive/update_server.sh
cp /tmp/QuakeLiveServer/check.sh /home/steam/quakelive/check.sh
cp /tmp/QuakeLiveServer/download_workshop.py /home/steam/quakelive/download_workshop.py
rm -rf /tmp/QuakeLiveServer
chmod +x /home/steam/quakelive/run_server.sh
chmod +x /home/steam/quakelive/update_server.sh
chmod +x /home/steam/quakelive/check.sh
mkdir -p /home/steam/quakelive/home
touch /home/steam/quakelive/home/workshop.txt
chown -R steam:steam /home/steam/quakelive
msg_ok "Set up Quake Live Server"

msg_info "Creating Service"
cat <<EOF >/etc/systemd/system/quakelive.service
[Unit]
Description=Quake Live Dedicated Server
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=/home/steam/quakelive
ExecStart=/bin/bash /home/steam/quakelive/run_server.sh
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
systemctl enable -q --now quakelive
msg_ok "Created Service"

motd_ssh

# Point the in-container "update" command at this repository
eval "$(declare -f customize | sed 's#https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct#https://raw.githubusercontent.com/RainingDaemons/QuakeLiveServer/lxc#g')"
customize
cleanup_lxc
