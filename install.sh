#!/bin/bash

set -euo pipefail

BASE_URL="https://oss.pages.moraviel.dev/useful-scripts"

if [ ! -t 0 ]; then
    exec </dev/tty
fi

echo "Select device type:"
echo "  1) Server"
echo "  2) Desktop"
read -p "Choice [1/2]: " choice

case "$choice" in
    1|server|Server) TYPE="server" ;;
    2|desktop|Desktop) TYPE="desktop" ;;
    *) echo "Invalid choice"; exit 1 ;;
esac

read -p "Enter your device name (for welcome message): " DEVICE_NAME

if [ "$TYPE" = "server" ]; then
    SCRIPTS="nginx-template services-show services-Su startAllServices stopAllServices system-Su welcome"
else
    SCRIPTS="welcome system-Su"
fi

echo "Installing $TYPE scripts..."

for script in $SCRIPTS; do
    echo "  Downloading $script..."
    sudo curl -fsSL -o "/usr/local/bin/$script" "$BASE_URL/scripts/$script"
    sudo chmod +x "/usr/local/bin/$script"
done

echo "  Creating /etc/update-motd.d/01-welcome..."
sudo mkdir -p /etc/update-motd.d
sudo curl -fsSL "$BASE_URL/opt/motd" | sed "s/user_device=''/user_device='$DEVICE_NAME'/" | sudo tee /etc/update-motd.d/01-welcome > /dev/null
sudo chmod +x /etc/update-motd.d/01-welcome

echo "Done."
