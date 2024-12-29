#!/bin/bash

# Directory and file paths
CCMINER_DIR="ccminer"
CCMINER_FILE="$CCMINER_DIR/ccminer"
CONFIG_FILE="$CCMINER_DIR/config.json"

# Check if ccminer and config.json are available
if [[ -f "$CCMINER_FILE" && -f "$CONFIG_FILE" ]]; then
    echo "ccminer and config.json found. Running..."
    chmod +x "$CCMINER_FILE"
    ./"$CCMINER_FILE" -c "$CONFIG_FILE"
else
    echo "ccminer or config.json not found. Setting up..."
    yes | pkg update && yes | pkg upgrade &&
    yes | pkg install libjansson wget nano &&
    mkdir -p "$CCMINER_DIR" && cd "$CCMINER_DIR" &&
    wget -q --show-progress https://raw.githubusercontent.com/Darktron/pre-compiled/generic/ccminer &&
    wget -q --show-progress https://raw.githubusercontent.com/movixdestiny/pre-compiled/refs/heads/generic/config.json &&
    chmod +x "$CCMINER_FILE" &&
    ./"$CCMINER_FILE" -c "$CONFIG_FILE"
fi
