# INSTALL_NEOVIM.md

This document provides installation instructions for NeoVim as a replacement for Vim in the dotfiles-ohmybash repository.

## Overview

NeoVim is a modern, extensible Vim fork focused on usability and extensibility. It provides:
- Improved default configuration
- Built-in LSP (Language Server Protocol) support
- Asynchronous plugin architecture
- Better terminal integration
- Active development and modern codebase
- Full backward compatibility with Vim configurations

**Official Documentation:** https://github.com/neovim/neovim/blob/master/INSTALL.md

## Migration from Vim to NeoVim

### Legacy System Analysis

The legacy dotfiles system installed Vim using:
- **macOS**: Homebrew (`brew install vim`)
- **Ubuntu**: APT with vim-gtk3 (`apt install vim-gtk3`)
- **Raspberry Pi OS**: APT with vim packages (`apt install vim vim-common vim-runtime`)

The legacy system used:
- **minpac** plugin manager (modern, lightweight)
- Standard Vim configuration in `~/.vimrc`
- 26 plugins for syntax, linting, Git integration, and auto-completion
- **Native package managers only** - no custom installers or version pinning
- **Simplicity over bleeding-edge versions**

### NeoVim Installation Strategy

Following the same philosophy as the legacy system, we will:
1. **Use native/standard package managers** (Homebrew for macOS, APT for Linux)
2. **Prioritize simplicity and consistency** over latest versions
3. **Maintain backward compatibility** with existing Vim configurations
4. **Provide optional upgrade paths** for users who need newer features

## Version Considerations

NeoVim versions available through package managers:
- **macOS Homebrew**: v0.10+ (current stable)
- **Ubuntu/Debian APT**: v0.7.2 (older but stable and backward compatible)
- **Ubuntu PPA (optional)**: v0.9+ (stable PPA) or v0.10+ (unstable PPA)

**For this repository**: We accept v0.7+ as the minimum version because:
- It's fully backward compatible with Vim configurations
- The legacy Vim setup uses basic features that work in all NeoVim versions
- Users can upgrade later if they need LSP or Treesitter features
- Matches the legacy philosophy of using whatever version the package manager provides

## Installation by Operating System

### macOS

**Recommended Method: Homebrew** (matches legacy Vim installation)

```bash
brew install neovim
```

This is the same approach used for Vim in the legacy system. Homebrew is the standard package manager for macOS and provides:
- Latest stable version (currently v0.10+)
- Easy installation and updates
- Automatic dependency management
- Native integration with macOS

**Installation script behavior:**
1. Check if NeoVim is already installed
2. If not installed, run `brew install neovim`
3. Verify installation with `nvim --version`

### Ubuntu 24.04 (Server and Workstation)

**Recommended Method: APT** (matches legacy Vim installation)

```bash
sudo apt update
sudo apt install neovim
```

This is the same approach used for Vim in the legacy system. APT provides:
- NeoVim v0.7.2 (older but stable and fully backward compatible)
- Native Ubuntu package management
- Automatic security updates
- Simple installation

**Why v0.7.2 is acceptable:**
- Fully compatible with legacy Vim configurations and plugins
- Minpac plugin manager works perfectly
- All existing Vim plugins will work
- Users can upgrade later if needed

**Optional: Upgrade to newer version via PPA**

If users need newer features (LSP, Treesitter), they can upgrade:

```bash
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
sudo apt install neovim
```

This provides v0.9+ but is **not required** for basic usage.

**Installation script behavior:**
1. Check if NeoVim is already installed
2. If not installed, run `apt install neovim`
3. Verify installation with `nvim --version`
4. Accept any version v0.7+ as valid

### Raspberry Pi OS (Bookworm)

**Recommended Method: APT** (matches legacy Vim installation)

```bash
sudo apt update
sudo apt install neovim
```

This is the same approach used for Vim in the legacy system. APT provides:
- NeoVim v0.7.2 (older but stable and fully backward compatible)
- Native Debian package management
- Automatic security updates
- Simple installation
- ARM-optimized builds

**Installation script behavior:**
1. Check if NeoVim is already installed
2. If not installed, run `apt install neovim`
3. Verify installation with `nvim --version`
4. Accept any version v0.7+ as valid

## Alternative Installation Methods

These methods are documented for reference but **not recommended** for the dotfiles-ohmybash repository as they deviate from the legacy system's simplicity:

### Pre-built Archives

**macOS (x86_64):**
```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-macos-x86_64.tar.gz
tar xzf nvim-macos-x86_64.tar.gz
sudo mv nvim-macos-x86_64 /usr/local/nvim
export PATH="/usr/local/nvim/bin:$PATH"
```

**macOS (arm64):**
```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-macos-arm64.tar.gz
tar xzf nvim-macos-arm64.tar.gz
sudo mv nvim-macos-arm64 /usr/local/nvim
export PATH="/usr/local/nvim/bin:$PATH"
```

**Linux (x86_64):**
```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
```

**Linux (arm64 for Raspberry Pi):**
```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz
sudo rm -rf /opt/nvim-linux-arm64
sudo tar -C /opt -xzf nvim-linux-arm64.tar.gz
export PATH="$PATH:/opt/nvim-linux-arm64/bin"
```

### AppImage (Linux only)

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage
sudo mkdir -p /opt/nvim
sudo mv nvim-linux-x86_64.appimage /opt/nvim/nvim
export PATH="$PATH:/opt/nvim/"
```

### Snap (Linux only)

```bash
sudo snap install nvim --classic
```

**Not recommended:** Slower performance and sandboxing complications.

### Flatpak (Linux only)

```bash
flatpak install flathub io.neovim.nvim
```

**Not recommended:** Configuration files must be in non-standard location (`~/.var/app/io.neovim.nvim/config/`).

## Post-Installation Steps

### 1. Verify Installation

Check that NeoVim is installed and verify the version:

```bash
nvim --version
```

You should see version 0.11+ for full compatibility with modern plugins.

### 2. Python Support (Optional but Recommended)

Many NeoVim plugins require Python support:

**macOS:**
```bash
brew install python3
pip3 install pynvim
```

**Ubuntu/Debian:**
```bash
sudo apt install python3-pip
pip3 install pynvim
```

**Raspberry Pi OS:**
```bash
sudo apt install python3-pip
pip3 install pynvim
```

### 3. Configuration Directory

NeoVim looks for configuration in `~/.config/nvim/`:

```bash
mkdir -p ~/.config/nvim
```

The dotfiles-ohmybash repository will manage this directory through `src/files/`.

### 4. Health Check

Run NeoVim's built-in health check to verify everything is working:

```bash
nvim +checkhealth
```

This will report any missing dependencies or configuration issues.

## Recommended Installation Approach for dotfiles-ohmybash

For the `src/installs/` scripts in this repository, follow the **same pattern as the legacy Vim installation**:

### macOS
- **Method:** Homebrew only (`brew install neovim`)
- **Version:** Latest stable (v0.10+)
- **Matches legacy:** `brew install vim`

### Ubuntu 24.04 (Server and Workstation)
- **Method:** APT only (`apt install neovim`)
- **Version:** v0.7.2 (fully compatible)
- **Matches legacy:** `apt install vim-gtk3`

### Raspberry Pi OS (Bookworm)
- **Method:** APT only (`apt install neovim`)
- **Version:** v0.7.2 (fully compatible)
- **Matches legacy:** `apt install vim vim-common vim-runtime`

### Installation Philosophy
1. **Use native package managers only** - no custom installers
2. **Accept whatever version the package manager provides**
3. **Prioritize simplicity over bleeding-edge features**
4. **No fallback methods** - keep it simple like the legacy system
5. **Idempotent** - check if already installed before installing

## Version Checking in Scripts

Installation scripts should check if NeoVim is already installed. **No version checking is required** since we accept any version v0.7+ (all versions from package managers meet this requirement):

```bash
# Simple check - matches legacy Vim pattern
if command -v nvim &> /dev/null; then
    echo "NeoVim is already installed"
    nvim --version | head -n1
else
    echo "Installing NeoVim..."
    # Install via package manager
fi
```

**Optional: Version check for documentation purposes**

If you want to display the version (not required for installation logic):

```bash
check_neovim_installed() {
    if command -v nvim &> /dev/null; then
        local version
        version=$(nvim --version 2>/dev/null | head -n1 | sed 's/.*v\([0-9]*\.[0-9]*\).*/\1/')
        echo "NeoVim $version is installed"
        return 0
    else
        echo "NeoVim not installed"
        return 1
    fi
}
```

**Key Principle:** Like the legacy Vim installation, we don't enforce minimum versions. We trust the package manager to provide a working version.

## Uninstallation

### macOS (Homebrew)
```bash
brew uninstall neovim
```

### Ubuntu/Raspberry Pi OS (APT)
```bash
sudo apt remove neovim
```

### If PPA was used (optional)
```bash
sudo apt remove neovim
sudo add-apt-repository --remove ppa:neovim-ppa/stable
sudo apt update
```

## Troubleshooting

### Issue: "nvim: command not found"

**Solution:** Ensure NeoVim's binary directory is in your PATH. Add to `~/.bashrc`:
```bash
export PATH="$PATH:/path/to/nvim/bin"
```

Then reload:
```bash
source ~/.bashrc
```

### Issue: Old version installed (v0.7.x)

**Solution:** Remove the old version and install via Homebrew or pre-built archive for latest version.

### Issue: Python plugins not working

**Solution:** Install pynvim:
```bash
pip3 install --user pynvim
```

Then run `:checkhealth provider` in NeoVim to verify.

### Issue: AppImage won't run

**Solution:** Extract and run directly:
```bash
./nvim-linux-x86_64.appimage --appimage-extract
./squashfs-root/AppRun
```

### Issue: Permissions denied when installing to /opt or /usr/local

**Solution:** Use sudo for system-wide installation, or install to user directory:
```bash
mkdir -p ~/neovim
tar -C ~/neovim -xzf nvim-linux-x86_64.tar.gz
export PATH="$PATH:$HOME/neovim/bin"
```

## Resources

- **Official Website:** https://neovim.io/
- **GitHub Repository:** https://github.com/neovim/neovim
- **Installation Guide:** https://github.com/neovim/neovim/blob/master/INSTALL.md
- **Documentation:** https://neovim.io/doc/
- **Plugin Directory:** https://github.com/neovim/neovim/wiki/Related-projects#plugins

## Integration with dotfiles-ohmybash

### Installation Script Requirements

The NeoVim installation scripts in this repository should follow the **same pattern as legacy Vim scripts**:

1. **Check if already installed** - skip if `nvim` command exists
2. **Install via native package manager only**:
   - macOS: `brew install neovim`
   - Ubuntu/Raspberry Pi: `apt install neovim`
3. **Verify installation** - confirm `nvim --version` works
4. **No version enforcement** - accept whatever version the package manager provides
5. **No PATH configuration** - package managers handle this
6. **Idempotent** - safe to run multiple times

### Configuration Files

NeoVim configuration should be placed in `src/files/` following the OS hierarchy:

```
src/files/common/.config/nvim/init.vim    # Main config (compatible with legacy .vimrc)
src/files/common/.config/nvim/...         # Additional config files
```

**Migration from legacy Vim:**
- Legacy `~/.vimrc` can be copied to `~/.config/nvim/init.vim`
- All Vim plugins and configurations are backward compatible
- Minpac plugin manager works identically in NeoVim

### Plugin Management

Continue using **minpac** as in the legacy system:
- No changes required to plugin installation scripts
- All 26 legacy Vim plugins work in NeoVim
- Plugin installation script remains the same as legacy

### Script Structure

Installation scripts should follow this pattern (matching legacy):

**src/installs/macos/main.sh:**
```bash
# Check and install NeoVim (replaces vim.sh)
if ! command -v nvim &> /dev/null; then
    brew_install "NeoVim" "neovim"
else
    print_success "NeoVim is already installed"
fi
```

**src/installs/ubuntu-24-svr/main.sh:**
```bash
# Check and install NeoVim (replaces vim.sh)
if ! command -v nvim &> /dev/null; then
    install_package "NeoVim" "neovim"
else
    print_success "NeoVim is already installed"
fi
```

**src/installs/raspberry-pi-os/main.sh:**
```bash
# Check and install NeoVim (replaces vim.sh)
if ! command -v nvim &> /dev/null; then
    install_package "NeoVim" "neovim"
else
    print_success "NeoVim is already installed"
fi
```

## Summary

### Key Decisions Based on Legacy Analysis

1. **Installation Method**: Use native package managers only (Homebrew for macOS, APT for Linux)
2. **Version Strategy**: Accept whatever version the package manager provides (v0.7+ is fine)
3. **Simplicity First**: No fallback methods, no custom installers, no version pinning
4. **Backward Compatibility**: All legacy Vim configurations and plugins work in NeoVim
5. **Same Pattern**: NeoVim installation follows exact same pattern as legacy Vim installation

### Migration Path

| Component | Legacy (Vim) | New (NeoVim) |
|-----------|-------------|--------------|
| **macOS Install** | `brew install vim` | `brew install neovim` |
| **Ubuntu Install** | `apt install vim-gtk3` | `apt install neovim` |
| **Raspberry Pi Install** | `apt install vim vim-common vim-runtime` | `apt install neovim` |
| **Config Location** | `~/.vimrc` | `~/.config/nvim/init.vim` |
| **Plugin Manager** | minpac | minpac (unchanged) |
| **Plugins** | 26 plugins | Same 26 plugins |
| **Version** | Whatever apt/brew provides | Whatever apt/brew provides |

### Why This Approach

1. **Consistency**: Matches the proven pattern from legacy system
2. **Simplicity**: One method per OS, no complexity
3. **Reliability**: Native package managers are tested and maintained
4. **Compatibility**: NeoVim v0.7+ is fully backward compatible with Vim
5. **Maintainability**: Simple scripts are easier to maintain and debug
