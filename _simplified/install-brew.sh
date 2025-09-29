#!/bin/bash

# Install Homebrew package manager
# This script downloads and installs Homebrew

main() {
    echo "Installing Homebrew..."
    
    # Download and run the official Homebrew installation script
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    echo "Homebrew installation completed!"
}

main
