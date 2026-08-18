#!/bin/bash

set -euo pipefail

BASE_URL="https://oss.pages.moraviel.dev/useful-scripts"

# Piping this script via `curl | sh` leaves stdin attached to the download
# stream rather than the terminal. Probe /dev/tty before reading from it so
# a missing/unusable tty fails fast with a helpful message instead of
# hanging forever on `read`.
prompt() {
    message="$1"
    if ( : </dev/tty ) 2>/dev/null; then
        printf '%s' "$message" >/dev/tty
        IFS= read -r REPLY </dev/tty
    elif [ -t 0 ]; then
        printf '%s' "$message"
        IFS= read -r REPLY
    else
        echo "No terminal available for interactive input." >&2
        echo "Set USEFUL_SCRIPTS_TYPE=server|desktop and USEFUL_SCRIPTS_DEVICE_NAME=<name> to run non-interactively." >&2
        exit 1
    fi
}

if [ -n "${USEFUL_SCRIPTS_TYPE:-}" ]; then
    choice="$USEFUL_SCRIPTS_TYPE"
else
    echo "Select device type:"
    echo "  1) Server"
    echo "  2) Desktop"
    prompt "Choice [1/2]: "
    choice="$REPLY"
fi

case "$choice" in
    1|server|Server) TYPE="server" ;;
    2|desktop|Desktop) TYPE="desktop" ;;
    *) echo "Invalid choice"; exit 1 ;;
esac

if [ -n "${USEFUL_SCRIPTS_DEVICE_NAME:-}" ]; then
    DEVICE_NAME="$USEFUL_SCRIPTS_DEVICE_NAME"
else
    prompt "Enter your device name (for welcome message): "
    DEVICE_NAME="$REPLY"
fi

if command -v pacman >/dev/null 2>&1; then
    PKG_MANAGER="pacman"
    sudo pacman -S cowsay
elif command -v apt >/dev/null 2>&1; then
    PKG_MANAGER="apt"
    sudo apt install cowsay
else
    echo "Unsupported package manager (expected apt or pacman)"; exit 1
fi

if [ "$TYPE" = "server" ]; then
    SCRIPTS="nginx-template services-show services-Su startAllServices stopAllServices welcome"
else
    SCRIPTS="welcome"
fi

echo "Installing $TYPE scripts..."

for script in $SCRIPTS; do
    echo "  Downloading $script..."
    sudo curl -fsSL -o "/usr/local/bin/$script" "$BASE_URL/scripts/$script"
    sudo chmod +x "/usr/local/bin/$script"
done

echo "  Downloading system-Su ($PKG_MANAGER)..."
sudo curl -fsSL -o "/usr/local/bin/system-Su" "$BASE_URL/scripts/system-Su-$PKG_MANAGER"
sudo chmod +x "/usr/local/bin/system-Su"

echo "  Creating /etc/update-motd.d/01-welcome..."
sudo mkdir -p /etc/update-motd.d
sudo curl -fsSL "$BASE_URL/opt/motd" | sed "s/user_device=''/user_device='$DEVICE_NAME'/" | sudo tee /etc/update-motd.d/01-welcome > /dev/null
sudo chmod +x /etc/update-motd.d/01-welcome

echo "Done."
