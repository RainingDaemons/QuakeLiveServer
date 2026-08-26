#!/bin/bash
# run_server.sh — Quake Live Run Config
hostname=$(grep '^hostname' config.toml | cut -d'=' -f2 | tr -d ' "\r')
password=$(grep '^password' config.toml | cut -d'=' -f2 | tr -d ' "\r')
net_port=$(grep '^net_port' config.toml | cut -d'=' -f2 | tr -d ' "\r')
fs_homepath=$(grep '^fs_homepath' config.toml | cut -d'=' -f2 | tr -d ' "\r')
sv_lan=$(grep '^sv_lan' config.toml | cut -d'=' -f2 | tr -d ' "\r')
sv_servertype=$(grep '^sv_servertype' config.toml | cut -d'=' -f2 | tr -d ' "\r')
zmq_stats_enable=$(grep '^zmq_stats_enable' config.toml | cut -d'=' -f2 | tr -d ' "\r')
zmq_stats_port=$(grep '^zmq_stats_port' config.toml | cut -d'=' -f2 | tr -d ' "\r')
zmq_stats_password=$(grep '^zmq_stats_password' config.toml | cut -d'=' -f2 | tr -d ' "\r')
zmq_rcon_enable=$(grep '^zmq_rcon_enable' config.toml | cut -d'=' -f2 | tr -d ' "\r')
zmq_rcon_port=$(grep '^zmq_rcon_port' config.toml | cut -d'=' -f2 | tr -d ' "\r')
zmq_rcon_password=$(grep '^zmq_rcon_password' config.toml | cut -d'=' -f2 | tr -d ' "\r')
linux_dir=$(grep '^linux_dir' config.toml | cut -d'=' -f2 | tr -d ' "\r')

mkdir -p "$fs_homepath"

cd "$linux_dir" || { echo "Error: Can't move to server directory"; exit 1; }

exec ./run_server_x64.sh \
    +set net_strict 1 \
    +set net_port "$net_port" \
    +set sv_hostname "$hostname" \
    +set g_password "$password" \
    +set fs_homepath "$fs_homepath" \
    +set sv_lan "$sv_lan" \
    +set sv_servertype "$sv_servertype" \
    +set zmq_stats_enable "$zmq_stats_enable" \
    +set zmq_stats_port "$zmq_stats_port" \
    +set zmq_stats_password "$zmq_stats_password" \
    +set zmq_rcon_enable "$zmq_rcon_enable" \
    +set zmq_rcon_port "$zmq_rcon_port" \
    +set zmq_rcon_password "$zmq_rcon_password"
