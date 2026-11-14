#!/usr/bin/env bash

set -euo pipefail

CONNECTION="direct-laptop"
PI_IP="10.77.0.2/24"

if [[ $EUID -ne 0 ]]; then
    echo "Run using sudo."
    exit 1
fi

IFACE=$(nmcli -t -f DEVICE,TYPE device status |
    awk -F: '$2 == "ethernet" { print $1; exit }')

if [[ -z "$IFACE" ]]; then
    echo "No Ethernet interface found."
    exit 1
fi

if nmcli connection show "$CONNECTION" >/dev/null 2>&1; then
    nmcli connection modify "$CONNECTION" \
        connection.interface-name "$IFACE" \
        ipv4.method manual \
        ipv4.addresses "$PI_IP" \
        ipv4.never-default yes \
        ipv6.method disabled \
        connection.autoconnect no
else
    nmcli connection add \
        type ethernet \
        con-name "$CONNECTION" \
        ifname "$IFACE" \
        ipv4.method manual \
        ipv4.addresses "$PI_IP" \
        ipv4.never-default yes \
        ipv6.method disabled \
        connection.autoconnect no
fi

nmcli connection up "$CONNECTION"

echo
echo "Direct Ethernet enabled."
echo "Pi: 10.77.0.2"
echo "Laptop: 10.77.0.1"
