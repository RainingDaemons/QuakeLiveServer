#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/misc/build.func)
# Copyright (c) 2021-2026 community-scripts.org
# Author: RainingDaemons
# License: MIT | https://github.com/community-scripts/ProxmoxVE/raw/main/LICENSE
# Source: https://store.steampowered.com/app/282440 | Github: https://github.com/RainingDaemons/QuakeLiveServer

APP="QuakeLive"
var_tags="${var_tags:-game;steam}"
var_cpu="${var_cpu:-2}"
var_ram="${var_ram:-2048}"
var_disk="${var_disk:-10}"
var_os="${var_os:-debian}"
var_version="${var_version:-12}"
var_arm64="${var_arm64:-no}"
var_unprivileged="${var_unprivileged:-1}"

header_info "$APP"
variables
color
catch_errors

# Fetch the installer from this repository instead of the community-scripts repo
eval "$(declare -f build_container | sed 's#https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/install#https://raw.githubusercontent.com/RainingDaemons/QuakeLiveServer/main/install#g')"

function update_script() {
  header_info
  check_container_storage
  check_container_resources
  if [[ ! -f /home/steam/quakelive/config.toml ]]; then
    msg_error "No ${APP} Installation Found!"
    exit
  fi

  msg_info "Stopping Service"
  systemctl stop quakelive
  msg_ok "Stopped Service"

  msg_info "Updating ${APP}"
  su - steam -c "cd /home/steam && ./steamcmd.sh +force_install_dir /home/steam/quakelive/qlds/ +login anonymous +app_update 349090 +quit"
  msg_ok "Updated ${APP}"

  msg_info "Starting Service"
  systemctl start quakelive
  msg_ok "Started Service"
  msg_ok "Updated successfully!"
  exit
}

start
build_container
description

msg_ok "Completed successfully!\n"
echo -e "${CREATING}${GN}${APP} setup has been successfully initialized!${CL}"
echo -e "${INFO}${YW}Connect using: ${BGN}${IP}:27960${CL}${YW} (UDP)${CL}"
echo -e "${INFO}${YW}Edit the server config at: ${BGN}/home/steam/quakelive/config.toml${CL}"
