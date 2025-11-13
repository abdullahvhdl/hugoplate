#!/bin/bash

# Cloudflare Pages Build Script for Hugo
# This script installs dependencies and builds the Hugo site

set -e

echo "=== Cloudflare Pages Build Script ==="
echo "Node version: $(node -v)"
echo "NPM version: $(npm -v)"

# Install Node.js dependencies
echo "Installing Node.js dependencies..."
npm install

# Install Hugo (if not already available)
if ! command -v hugo &> /dev/null; then
    echo "Hugo not found. Installing Hugo Extended 0.151.0..."
    HUGO_VERSION="0.151.0"
    curl -sSOL "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz"
    tar -xzf "hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz"
    mkdir -p ~/.local/bin
    mv hugo ~/.local/bin/
    export PATH=$PATH:~/.local/bin
    rm -rf "hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz"
    hugo version
fi

# Install Go (required for Hugo modules)
if ! command -v go &> /dev/null; then
    echo "Go not found. Installing Go 1.25.1..."
    GO_VERSION="1.25.1"
    curl -sSOL "https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz"
    mkdir -p ~/go-install
    tar -C ~/go-install -xzf "go${GO_VERSION}.linux-amd64.tar.gz"
    export PATH=$PATH:~/go-install/go/bin
    export GOROOT=~/go-install/go
    rm -rf "go${GO_VERSION}.linux-amd64.tar.gz"
    go version
fi

# Run project setup
echo "Running project setup..."
npm run project-setup

# Build the site
echo "Building the site..."
npm run build

echo "=== Build Complete ==="
echo "Output directory: public/"

