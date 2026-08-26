#!/bin/bash
# check.sh
# Server setup checker for Quake Live Server
configPath="$(dirname "$0")/config.toml"
linux_dir=$(grep '^linux_dir' "$configPath" | cut -d'=' -f2 | tr -d ' "\r')

if [ -z "$linux_dir" ]; then
    linux_dir="/home/steam/quakelive/qlds"
    echo "linux_dir is not set in config.toml, using default dir: $linux_dir"
    sed -i "s|^linux_dir[[:space:]]*=.*|linux_dir = \"$linux_dir\"|" "$configPath"
fi

qldsFolder="$linux_dir"
runScript="$qldsFolder/run_server_x64.sh"

passed=0
total=5

if [ -n "$linux_dir" ]; then
    echo "[✓] linux_dir configured"
    passed=$((passed + 1))
else
    echo "[x] linux_dir configured"
fi

if [ -d "$qldsFolder" ]; then
    echo "[✓] QLDS install folder"
    passed=$((passed + 1))
else
    echo "[x] QLDS install folder"
fi

if [ -x "$runScript" ]; then
    echo "[✓] run_server_x64.sh present and executable"
    passed=$((passed + 1))
else
    echo "[x] run_server_x64.sh present and executable"
fi

check_pkgs() {
    local label="$1"
    shift
    local missing=0
    for pkg in "$@"; do
        if ! dpkg -s "$pkg" >/dev/null 2>&1; then
            missing=1
        fi
    done
    if [ "$missing" -eq 0 ]; then
        echo "[✓] $label"
        passed=$((passed + 1))
    else
        echo "[x] $label"
    fi
}

check_pkgs "32-bit libs installed" lib32gcc-s1 lib32stdc++6 lib32z1

if python3 -c "import zmq" >/dev/null 2>&1; then
    echo "[✓] python3/pip3/pyzmq installed"
    passed=$((passed + 1))
else
    echo "[x] python3/pip3/pyzmq installed"
fi

if [ "$passed" -eq "$total" ]; then
    echo "[$passed/$total] passed - Server setup is done"
else
    echo "[$passed/$total] passed - Server needs some fixes"
fi
