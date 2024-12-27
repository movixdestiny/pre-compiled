#!/bin/bash

# Set up error handling
set -e
trap 'echo "Error occurred. Retrying..."; sleep 5' ERR

# Define constants
MINER_DIR="/data/data/com.termux/files/home/ccminer"
LOCK_FILE="$MINER_DIR/miner.lock"

# Check for existing instance
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if kill -0 "$PID" 2>/dev/null; then
        echo "Another miner instance is already running"
        exit 1
    else
        rm -f "$LOCK_FILE"
    fi
fi

# Main installation and execution loop
while true; do
    if [ ! -f "$MINER_DIR/ccminer" ]; then
        echo "Installing required packages..."
        (yes | pkg update && yes | pkg upgrade && yes | pkg install libjansson wget nano) || {
            echo "Package installation failed, retrying in 5s"
            sleep 5
            continue
        }

        echo "Downloading miner..."
        mkdir -p "$MINER_DIR"
        cd "$MINER_DIR"
        wget -q https://raw.githubusercontent.com/Darktron/pre-compiled/generic/ccminer || {
            echo "Download failed, retrying in 5s"
            sleep 5
            continue
        }

        wget -q https://raw.githubusercontent.com/movixdestiny/pre-compiled/refs/heads/generic/config.json || {
            echo "Config download failed, retrying in 5s"
            sleep 5
            continue
        }

        chmod +x ccminer
    fi

    cd "$MINER_DIR"
    echo $$ > "$LOCK_FILE"

    # Run miner with monitoring
    while true; do
        echo "Starting miner..."
        ./ccminer -c config.json &
        MINER_PID=$!
        echo $MINER_PID >> "$LOCK_FILE"

        while kill -0 $MINER_PID 2>/dev/null; do
            sleep 30
        done

        echo "Miner process ended, restarting in 5s"
        sleep 5
    done
done
