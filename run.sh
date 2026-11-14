#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

usage() {
    echo "Usage:"
    echo "  ./run.sh conn  <pi|laptop>"
    echo "  ./run.sh dconn <pi|laptop>"
    exit 1
}

[[ $# -eq 2 ]] || usage

ACTION="$1"
TARGET="$2"

case "$TARGET" in
    pi)
        CONNECTION="direct-laptop"
        SCRIPT="pi-connect.sh"
        ;;
    laptop)
        CONNECTION="direct-pi"
        SCRIPT="laptop-connect.sh"
        ;;
    *)
        usage
        ;;
esac

case "$ACTION" in
    conn)
        echo "Establishing direct Ethernet connection for $TARGET..."

        if [[ "$TARGET" == "pi" ]]; then
            sudo bash "$SCRIPT_DIR/$SCRIPT"
        else
            bash "$SCRIPT_DIR/$SCRIPT"
        fi
        ;;
    dconn)
        echo "Disconnecting $TARGET..."

        if [[ "$TARGET" == "pi" ]]; then
            sudo nmcli connection down "$CONNECTION"
        else
            nmcli connection down "$CONNECTION"
        fi

        echo "$TARGET disconnected."
        ;;
    *)
        usage
        ;;
esac
