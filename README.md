# Proxmox LXC - Quake Live Server

## What is this?

This repository is intended to provide some useful scripts for setting up your own Quake Live Dedicated Server (QLDS) using LXC (Linux Containers) from Proxmox.

---

## How it works?

Run the command below in the Proxmox VE Shell to create a Quake Live Server:

```
bash -c "$(curl -fsSL https://raw.githubusercontent.com/RainingDaemons/QuakeLiveServer/refs/heads/main/quakelive.sh)"
```

## Server configuration

Edit the server configuration file named `config.toml` and fill this required variables:

- **hostname:** is the name of the server as shown in the server browser.
- **password:** is the password that will be used to connect to the server, it can be left empty if it is not required.
- **net_port:** is the UDP port the game will listen on (default `27960`).
- **fs_homepath:** is the directory where the server stores its runtime files (`server.cfg`, `access.txt`, `mappool.txt`, `workshop.txt`, ...).
- **sv_lan:** set to `1` only for LAN testing, per the guide troubleshooting notes.
- **sv_servertype:** `0` offline, `1` LAN, `2` internet.
- **zmq_stats_enable / zmq_stats_port / zmq_stats_password:** external ZeroMQ stats socket (used by tools like qlstats).
- **zmq_rcon_enable / zmq_rcon_port / zmq_rcon_password:** external ZeroMQ remote console.
- **linux_dir:** path to the installed QLDS binaries.

## Restart server service

If changes were made in server config or server version was updated, execute the following commands:

```
systemctl daemon-reload
systemctl restart quakelive.service
```

## Playing with steam workshop content

Inside `/home/steam/quakelive/home` create a file named `workshop.txt` with the IDs of the workshop items you want to download, for example:

```
# Specify 1 workshop item id per line
2824816332
3137996356
```

Then run the following script to autodownload your mods:

```
./download_mods.sh
```

Then restart the server, now your workshop content will be automatically loaded.
