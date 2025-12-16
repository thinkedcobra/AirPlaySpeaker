#!/bin/bash

# AirPlaySpeaker Installer Script
# Installs dependencies and builds shairport-sync with metadata support

set -e

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting AirPlaySpeaker installation...${NC}"

# Check for sudo
if [ "$EUID" -ne 0 ]; then 
  echo -e "${RED}Please run as root (sudo ./install.sh)${NC}"
  exit 1
fi

# Update System
echo -e "${YELLOW}Updating package lists...${NC}"
apt-get update && apt-get upgrade -y

# Install Build Dependencies
echo -e "${YELLOW}Installing build dependencies...${NC}"
apt-get install -y --no-install-recommends \
    build-essential \
    git \
    xmltoman \
    autoconf \
    automake \
    libtool \
    libpopt-dev \
    libconfig-dev \
    libasound2-dev \
    avahi-daemon \
    libavahi-client-dev \
    libssl-dev \
    libsoxr-dev \
    libplist-dev \
    libsodium-dev \
    libavutil-dev \
    libavcodec-dev \
    libavformat-dev \
    uuid-dev \
    libgcrypt-dev \
    xxd \
    libglib2.0-dev \
    python3-dbus \
    python3-gi \
    python3-waitress

# Clone Shairport Sync
cd /tmp
if [ -d "shairport-sync" ]; then
    echo -e "${YELLOW}Removing existing temporary shairport-sync directory...${NC}"
    rm -rf shairport-sync
fi

echo -e "${YELLOW}Cloning shairport-sync...${NC}"
git clone https://github.com/mikebrady/shairport-sync.git
cd shairport-sync

# Configure and Build
echo -e "${YELLOW}Configuring build...${NC}"
autoreconf -fi
./configure \
    --sysconfdir=/etc \
    --with-alsa \
    --with-avahi \
    --with-ssl=openssl \
    --with-soxr \
    --with-metadata \
    --with-dbus-interface \
    --with-systemd

echo -e "${YELLOW}Compiling... (this may take a few minutes)${NC}"
make -j$(nproc)

echo -e "${YELLOW}Installing...${NC}"
make install

# Enable Service
echo -e "${YELLOW}Enabling shairport-sync service...${NC}"

# Install Config
if [ -f "shairport-sync.conf" ]; then
    echo -e "${YELLOW}Installing default configuration to /etc/shairport-sync.conf...${NC}"
    # Backup existing config if it exists
    if [ -f "/etc/shairport-sync.conf" ]; then
        mv /etc/shairport-sync.conf /etc/shairport-sync.conf.bak
    fi
    cp shairport-sync.conf /etc/shairport-sync.conf
fi

systemctl enable shairport-sync
systemctl start shairport-sync

# WiFi Power Management Fix (Optional but recommended for Pi)
if command -v iwconfig &> /dev/null; then
    echo -e "${YELLOW}Disabling WiFi power management for stability...${NC}"
    iwconfig wlan0 power off || echo -e "${RED}Could not disable WiFi power management (interface might differ).${NC}"
fi

echo -e "${GREEN}Installation Complete!${NC}"
echo -e "Your device should now be visible as an AirPlay speaker."
echo -e "Edit /etc/shairport-sync.conf to change the hostname or settings."
