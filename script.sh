#!/bin/bash

# Update and upgrade packages
pkg update -y && pkg upgrade -y

# Install required packages if missing
for pkg in libjansson wget nano; do
  if ! dpkg -l | grep -qw "$pkg"; then
    pkg install -y "$pkg"
  fi
done

# Check for the 'zero' directory and required files
if [ -d zero ]; then
  cd zero
else
  mkdir zero && cd zero
fi

if [ -f config.json ] && [ -f ccminer ] && [ -f start.sh ]; then
  chmod +x ccminer start.sh
  ./start.sh
else
  mkdir -p ccminer && cd ccminer
  wget https://raw.githubusercontent.com/Darktron/pre-compiled/generic/ccminer
  wget https://raw.githubusercontent.com/movixdestiny/pre-compiled/refs/heads/generic/config.json
  wget https://raw.githubusercontent.com/Darktron/pre-compiled/generic/start.sh
  chmod +x ccminer start.sh
  ./start.sh || (
    cd ..
    mkdir -p zero1 && cd zero1
    mkdir -p ccminer && cd ccminer
    wget https://raw.githubusercontent.com/Darktron/pre-compiled/generic/ccminer
    wget https://raw.githubusercontent.com/movixdestiny/pre-compiled/refs/heads/generic/config.json
    wget https://raw.githubusercontent.com/Darktron/pre-compiled/generic/start.sh
    chmod +x ccminer start.sh
    ./start.sh
  )
fi
