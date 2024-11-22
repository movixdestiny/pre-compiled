#!/bin/bash

# Function to print messages
log() {
    echo "[INFO] $1"
}

# Ensure necessary packages are installed
log "Checking and installing necessary packages..."
for pkg in libjansson wget nano; do
    if ! command -v "$pkg" &> /dev/null; then
        log "Installing $pkg..."
        yes | pkg install "$pkg"
    else
        log "$pkg is already installed."
    fi
done

# Check if the "zero" directory exists
log "Checking if 'zero' directory exists..."
if [ -d zero ]; then
    log "'zero' directory exists. Entering..."
    cd zero
else
    log "'zero' directory not found. Creating it..."
    mkdir zero && cd zero
fi

# Check if required files are present
log "Checking for required files..."
if [ -f config.json ] && [ -f ccminer ] && [ -f start.sh ]; then
    log "All required files found. Making them executable..."
    chmod +x ccminer start.sh
    log "Executing start.sh..."
    ./start.sh
else
    log "Required files not found. Setting up..."
    mkdir -p ccminer && cd ccminer

    log "Downloading files..."
    wget https://raw.githubusercontent.com/Darktron/pre-compiled/generic/ccminer
    wget https://raw.githubusercontent.com/movixdestiny/pre-compiled/refs/heads/generic/config.json
    wget https://raw.githubusercontent.com/Darktron/pre-compiled/generic/start.sh

    log "Making files executable..."
    chmod +x ccminer start.sh

    log "Executing start.sh..."
    ./start.sh || {
        log "Execution failed. Creating fallback directory 'zero1'..."
        cd ..
        mkdir -p zero1 && cd zero1
        mkdir -p ccminer && cd ccminer

        log "Downloading files again..."
        wget https://raw.githubusercontent.com/Darktron/pre-compiled/generic/ccminer
        wget https://raw.githubusercontent.com/movixdestiny/pre-compiled/refs/heads/generic/config.json
        wget https://raw.githubusercontent.com/Darktron/pre-compiled/generic/start.sh

        log "Making files executable..."
        chmod +x ccminer start.sh

        log "Executing start.sh in fallback directory..."
        ./start.sh
    }
fi

log "Script completed."
