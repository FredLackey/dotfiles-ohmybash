# Simplified Installation Scripts

This folder contains simplified, standalone installation scripts that provide a direct approach to setting up development environments without the complexity of the main dotfiles repository.

## Purpose

The `_simplified` folder offers the most streamlined way to install essential tools and packages. Unlike the main dotfiles repository which uses helper functions, utility scripts, and complex orchestration, these scripts take a minimal approach:

- **No helper functions** - Each script contains only the essential commands needed
- **No external dependencies** - Scripts don't rely on utility functions from other parts of the repo
- **Single responsibility** - Each script focuses on one specific task
- **Direct execution** - Simple command-line operations without abstraction layers

## Philosophy

These scripts are designed for users who want:
- Quick, straightforward installations
- Full visibility into what each script does
- Minimal dependencies and complexity
- Easy customization and modification

## Available Scripts

### `install-brew.sh`
Installs Homebrew package manager on macOS. This is a simple wrapper around the official Homebrew installation command.

### `install-brew-packages.sh`
Installs essential packages using Homebrew. Contains direct `brew install` commands without any utility functions or complex logic.

### `set-mac-preferences.sh`
Configures macOS system preferences using direct `defaults write` commands. Organizes settings into logical functions for Dock, Finder, Keyboard, Safari, Chrome, Terminal, Trackpad, UI/UX, Security, Language, Maps, Photos, TextEdit, Firefox, and App Store preferences.

## Usage

Each script can be run independently:

```bash
# Install Homebrew
./install-brew.sh

# Install packages with Homebrew
./install-brew-packages.sh

# Set macOS system preferences
./set-mac-preferences.sh
```

## Comparison with Main Repository

| Aspect | Main Repository | Simplified |
|--------|----------------|------------|
| **Complexity** | High - uses utility functions, error handling, logging | Low - direct commands only |
| **Dependencies** | Many - relies on shared utilities | None - completely standalone |
| **Customization** | Requires understanding of the codebase | Easy - just edit the commands |
| **Error Handling** | Comprehensive logging and error management | Basic - relies on command exit codes |
| **Maintenance** | Centralized utilities, harder to modify | Individual scripts, easy to modify |

## Future Scripts

This folder will be expanded with additional simplified installation scripts for:
- Node.js and npm packages
- Development tools
- System utilities
- Configuration files

Each new script will follow the same principles of simplicity and directness.
