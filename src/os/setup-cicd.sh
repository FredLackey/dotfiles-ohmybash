#!/bin/bash

# CI/CD Setup Script
# 
# This script is a wrapper for setup.sh that automatically answers "yes" to all
# prompts, making it suitable for automated deployments, containers, and CI/CD
# pipelines.
#
# Usage:
#   Local: ./setup-cicd.sh
#   Remote: bash -c "$(wget -qO - https://raw.github.com/fredlackey/dotfiles/main/src/os/setup-cicd.sh)"
#   Remote: bash -c "$(curl -fsSL https://raw.github.com/fredlackey/dotfiles/main/src/os/setup-cicd.sh)"
#
# This is equivalent to:
#   ./setup.sh -y

declare -r SETUP_URL="https://raw.githubusercontent.com/fredlackey/dotfiles/main/src/os/setup.sh"

# Check if we're running from a local directory or being piped
if [ -f "setup.sh" ]; then
    # Local execution - setup.sh exists in current directory
    ./setup.sh -y
else
    # Remote execution - download and run setup.sh
    if command -v curl &> /dev/null; then
        bash <(curl -fsSL "$SETUP_URL") -y
    elif command -v wget &> /dev/null; then
        bash <(wget -qO - "$SETUP_URL") -y
    else
        echo "Error: Neither curl nor wget is available"
        exit 1
    fi
fi

