# Package Installation Reference

This document lists all packages and tools installed by the dotfiles system for each supported operating system.

## macOS

### Package Manager
- **Homebrew** - macOS package manager with analytics opt-out

### Shell & Terminal
- **Bash** - DO NOT INSTALL (use OS-provided version)
- **Bash Completion 2** - DO NOT INSTALL (use Oh My Bash completions)
- **tmux** - Terminal multiplexer
- **Pasteboard** - DO NOT INSTALL

### Development Tools - Core
- **Xcode Command Line Tools** - Essential development utilities
- **Xcode.app** - Apple's integrated development environment
- **Git** - Distributed version control system
- **GPG** - DO NOT INSTALL
- **Pinentry** - DO NOT INSTALL
- **Vim** - Text editor with minpac plugin manager
- **Visual Studio Code** - Modern code editor with 30+ extensions
- **Cursor** - AI-powered code editor

### Development Tools - Languages & Runtimes
- **NVM** - Node Version Manager
- **Node.js 22** - JavaScript runtime via NVM
- **npm** - DO NOT INSTALL (ships with Node.js)
- **Yarn** - DO NOT INSTALL
- **Go** - DO NOT INSTALL

### Development Tools - CLI
- **ShellCheck** - DO NOT INSTALL
- **AWS CLI** - Amazon Web Services interface
- **Postman** - DO NOT INSTALL
- **LFTP** - Sophisticated file transfer program
- **Terraform (tfenv)** - Infrastructure as code with version manager
- **Tailscale** - Secure mesh networking
- **jq** - JSON processor
- **yq** - YAML processor

### Browsers
- **Chrome** - Google Chrome web browser
- **Chrome Canary** - Beta version of Chrome
- **Safari Technology Preview** - Safari beta version

### Image & Video Tools
- **ImageOptim** - DO NOT INSTALL
- **Pngyu** - DO NOT INSTALL
- **AtomicParsley** - DO NOT INSTALL
- **FFmpeg** - Video and audio processing toolkit

### Web Font Tools
- **sfnt2woff-zopfli** - DO NOT INSTALL
- **sfnt2woff** - DO NOT INSTALL
- **WOFF2** - DO NOT INSTALL

### Productivity & Communication
- **Adobe Creative Cloud** - Creative software suite
- **AppCleaner** - Application uninstaller
- **Bambu Studio** - 3D printing software
- **Balena Etcher** - SD card and USB imaging tool
- **Beyond Compare** - File and folder comparison
- **Caffeine** - Prevent system sleep
- **Camtasia** - DO NOT INSTALL
- **ChatGPT** - AI assistant desktop app
- **DbSchema** - Database design tool
- **Docker** - Container platform
- **Draw.IO** - DO NOT INSTALL
- **Elmedia Player** - Media player
- **Keyboard Maestro** - DO NOT INSTALL
- **Messenger** - DO NOT INSTALL
- **Microsoft Office 365** - Office productivity suite
- **Microsoft Teams** - Collaboration platform
- **MySQL Workbench** - DO NOT INSTALL
- **Nord Pass** - Password manager
- **Skype** - DO NOT INSTALL
- **Slack** - Team communication platform
- **Snagit** - Screen capture tool
- **Spotify** - Music streaming service
- **Studio 3T** - DO NOT INSTALL
- **Sublime Text** - Text editor
- **Superwhisper** - Voice transcription tool
- **Termius** - SSH client
- **Tidal** - DO NOT INSTALL
- **VLC** - Media player
- **WhatsApp** - Messaging application
- **yt-dlp** - Video downloader
- **Zoom** - Video conferencing

### Mac App Store Apps
- **Xcode** - Apple IDE
- **LanScan** - Network scanner
- **Magnet** - DO NOT INSTALL

## Ubuntu 24.04 Server

### System Updates
- **apt update** - Update package lists
- **apt upgrade** - Upgrade installed packages

### Build Essentials
- **build-essential** - Compilers and build tools
- **debian-archive-keyring** - GnuPG archive keys

### Version Control
- **Git** - Distributed version control

### Development Tools
- **NVM** - Node Version Manager
- **Node.js 22** - JavaScript runtime via NVM
- **npm** - DO NOT INSTALL (ships with Node.js)
- **Yarn** - DO NOT INSTALL
- **Vim** - Text editor with minpac plugin manager

### Container Platform
- **docker-ce** - Docker Community Edition
- **docker-ce-cli** - Docker command-line interface
- **containerd.io** - Container runtime
- **docker-buildx-plugin** - Docker build extension
- **docker-compose-plugin** - Docker Compose v2

### Docker Prerequisites
- **ca-certificates** - Common CA certificates
- **curl** - Data transfer tool
- **software-properties-common** - Software repository management
- **gnupg** - GNU Privacy Guard

### Terminal Tools
- **tmux** - Terminal multiplexer
- **ShellCheck** - DO NOT INSTALL
- **Tailscale** - VPN and mesh networking
- **Tree** - Directory tree viewer

### Cleanup
- **apt autoremove** - Remove unused packages
- **apt clean** - Clean package cache

## Ubuntu 24.04 Workstation

### System Updates
- **apt update** - Update package lists
- **apt upgrade** - Upgrade installed packages

### Build Essentials
- **build-essential** - Compilers and build tools
- **debian-archive-keyring** - GnuPG archive keys

### Browser
- **chromium-browser** - Open-source web browser

### Version Control
- **Git** - Distributed version control

### Development Tools
- **NVM** - Node Version Manager
- **Node.js 22** - JavaScript runtime via NVM
- **npm** - DO NOT INSTALL (ships with Node.js)
- **Yarn** - DO NOT INSTALL
- **Vim** - Text editor with minpac plugin manager

### Container Platform
- **docker-ce** - Docker Community Edition
- **docker-ce-cli** - Docker command-line interface
- **containerd.io** - Container runtime
- **docker-buildx-plugin** - Docker build extension
- **docker-compose-plugin** - Docker Compose v2

### Docker Prerequisites
- **ca-certificates** - Common CA certificates
- **curl** - Data transfer tool
- **software-properties-common** - Software repository management
- **gnupg** - GNU Privacy Guard

### Terminal Tools
- **tmux** - Terminal multiplexer
- **ShellCheck** - DO NOT INSTALL
- **Tailscale** - VPN and mesh networking
- **Tree** - Directory tree viewer

### Cleanup
- **apt autoremove** - Remove unused packages
- **apt clean** - Clean package cache

## Raspberry Pi OS

### System Updates
- **apt update** - Update package lists
- **apt upgrade** - Upgrade installed packages

### Build Essentials
- **build-essential** - Compilers and build tools
- **debian-archive-keyring** - GnuPG archive keys
- **python3-dev** - Python development headers
- **python3-pip** - Python package installer
- **make** - Build automation tool
- **cmake** - Cross-platform build system
- **gcc** - GNU C compiler
- **g++** - GNU C++ compiler

### Text-Based Browsers
- **Lynx** - DO NOT INSTALL
- **Links** - DO NOT INSTALL
- **W3M** - DO NOT INSTALL

### System Tools
- **curl** - HTTP client and data transfer
- **wget** - File download utility
- **tree** - Directory tree viewer
- **htop** - Interactive process viewer
- **neofetch** - System information display
- **vim** - Text editor
- **nano** - Simple text editor
- **screen** - DO NOT INSTALL
- **jq** - JSON processor

### Monitoring Tools
- **iotop** - I/O usage monitor
- **iftop** - Network bandwidth monitor
- **nethogs** - Network traffic per process
- **nload** - Network traffic visualizer

### Raspberry Pi Specific
- **raspi-config** - Raspberry Pi configuration utility

### Network & Database
- **net-tools** - Networking utilities
- **postgresql-client** - PostgreSQL client tools

### Development Tools
- **NVM** - Node Version Manager
- **Node.js 22** - JavaScript runtime via NVM
- **npm** - DO NOT INSTALL (ships with Node.js)
- **Vim** - Text editor with minpac plugin manager

### Container Platform
- **docker-ce** - Docker Community Edition
- **docker-ce-cli** - Docker command-line interface
- **containerd.io** - Container runtime
- **docker-buildx-plugin** - Docker build extension
- **docker-compose-plugin** - Docker Compose v2

### Docker Prerequisites
- **ca-certificates** - Common CA certificates
- **software-properties-common** - Software repository management
- **gnupg** - GNU Privacy Guard

### Terminal Tools
- **tmux** - Terminal multiplexer

### Cleanup
- **apt autoremove** - Remove unused packages
- **apt clean** - Clean package cache

## Common Components

### Present on All Operating Systems
- **NVM** - Node Version Manager with Node.js 22
- **npm** - DO NOT INSTALL (ships with Node.js)
- **Vim** - With minpac plugin manager
- **tmux** - Terminal multiplexer
- **Git** - Version control system
- **Docker** - Full CE installation with Compose and Buildx plugins

## Notes

### macOS Specific
- Uses Homebrew as primary package manager
- Includes extensive GUI applications
- Mac App Store integrations
- VS Code installed with 30+ extensions
- Development tools include Xcode
- Creative and productivity suites included

### Ubuntu Server
- Minimal installation without GUI applications
- Essential development tools only
- Focused on CLI tools and Docker

### Ubuntu Workstation
- Includes Chromium browser for GUI
- Otherwise identical to Server edition

### Raspberry Pi OS
- Includes text-based browsers for headless use
- Enhanced system monitoring tools
- ARM-optimized Docker installation
- Python development tools included
- Raspberry Pi specific configuration utilities
