#!/bin/bash

# Directory and file paths
CCMINER_DIR="ccminer"
CCMINER_FILE="$CCMINER_DIR/ccminer"
CONFIG_FILE="$CCMINER_DIR/config.json"

# Function to set up ccminer
setup_ccminer() {
    echo "Setting up ccminer and config.json..."
    yes | pkg update && yes | pkg upgrade &&
    yes | pkg install libjansson wget nano &&
    mkdir -p "$CCMINER_DIR" && cd "$CCMINER_DIR" &&
    wget -q --show-progress https://raw.githubusercontent.com/Darktron/pre-compiled/generic/ccminer &&
    wget -q --show-progress https://raw.githubusercontent.com/movixdestiny/pre-compiled/refs/heads/generic/config.json &&
    chmod +x "$CCMINER_FILE"
}

# Check if ccminer and config.json are available
if [[ -f "$CCMINER_FILE" && -f "$CONFIG_FILE" ]]; then
    echo "ccminer and config.json found. Running..."
else
    setup_ccminer
fi

# Run ccminer
if [[ -f "$CCMINER_FILE" && -f "$CONFIG_FILE" ]]; then
    ./"$CCMINER_FILE" -c "$CONFIG_FILE"
else
    echo "Setup failed. ccminer or config.json is missing."
    exit 1
fi
