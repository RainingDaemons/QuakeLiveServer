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

Check in `/home/steam/quakelive/qlds/baseq3/server.cfg` if the following vars are set:
```
set sv_mapPoolFile "mappool.txt"
set serverstartup "startRandomMap"
```

Now inside `/home/steam/quakelive/qlds/baseq3/workshop.txt` add the IDs of the workshop items you want to download, for example:
```
# Specify 1 workshop item id per line
1502166021
572015381
```

Then restart the server, now your workshop content will be automatically loaded.

## Creating a Map Pool

In `/home/steam/quakelive/qlds/baseq3/mappool.txt` specify the maps for the rotation pool including a `factoryid` to define the game mode for each map:
```
# specify 1 map per line, mapname|factoryid
# ex: aerowalk|ffa
# see factories.txt for valid factory id values
hangtime|ffa
ql_dust2|ffa
```

## Admin access

To grant administrator access to a user, you need their `steamID64`, which is available using a service like [SteamID.io](https://steamid.io/). Then add it to `/home/steam/quakelive/qlds/baseq3/access.txt` specifying the corresponding role:
```
steamid64|admin
```
