#!/bin/bash
# update_server.sh — Quake Live Server Update Script
su - steam -c "cd /home/steam && ./steamcmd.sh \
    +force_install_dir /home/steam/quakelive/qlds/ \
    +login anonymous \
    +app_update 349090 \
    +quit"
