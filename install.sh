#!/usr/bin/env bash

# Exit on error
set -e

echo "=== Sticky Notes Installer ==="

# Check OS distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
else
    OS=$(uname -s)
    VER=""
fi

echo "OS Detected: $OS ($VER)"

# Ensure we are running on Debian/Ubuntu-based system for apt
if [ -x "$(command -v apt-get)" ]; then
    echo "Installing system dependencies via apt..."
    sudo apt-get update
    sudo apt-get install -y \
        libgjs-dev \
        libadwaita-1-dev \
        libgtk-4-dev \
        nodejs \
        npm \
        meson \
        ninja-build \
        git
else
    echo "Warning: apt-get not found. Please make sure libgjs-dev, libadwaita-1-dev, libgtk-4-dev, nodejs, npm, meson, and ninja-build are installed manually."
fi

# Ensure yarn is installed
if ! [ -x "$(command -v yarn)" ]; then
    echo "Yarn not found. Installing yarn globally via npm..."
    if [ -d "$HOME/.npm-global/bin" ]; then
        npm install -g yarn
    else
        sudo npm install -g yarn
    fi
fi

# Clean old build if exists
if [ -d "build" ]; then
    echo "Removing existing build directory..."
    rm -rf build
fi

# Setup and compile project
echo "Configuring project with Meson..."
meson setup build

echo "Compiling project..."
meson compile -C build

echo "=== Installation & Build Complete! ==="
echo "Untuk menjalankan aplikasi dalam mode development, jalankan perintah berikut:"
echo "  meson compile -C build devel"
