# Prerequisites

This document identifies the foundational prerequisites that must be present on each operating system **before** the dotfiles system can be installed. These are the absolute minimum requirements for the setup process to function.

## Overview

Prerequisites are system-level dependencies that the dotfiles setup process requires to:
1. Download and extract the dotfiles repository
2. Execute shell scripts and utility functions
3. Install package managers and build tools
4. Compile and build software from source

**Important:** These prerequisites must be installed FIRST, before any dotfiles installation begins.

## Phase 0: Dotfiles Download and Preparation (FIRST STEP)

**Before** installing any prerequisites, the dotfiles must be downloaded and prepared on the local system. This is the absolute first step in the entire process.

### Download Process

The setup script can be executed remotely, which automatically handles downloading the dotfiles:

**macOS:**
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/fredlackey/dotfiles-ohmybash/main/src/setup.sh)"
```

**Ubuntu/Raspberry Pi OS:**
```bash
bash -c "$(wget -qO - https://raw.githubusercontent.com/fredlackey/dotfiles-ohmybash/main/src/setup.sh)"
```

### What Happens During Download

1. **Download GitHub Tarball**
   - Downloads latest version from: `https://github.com/fredlackey/dotfiles-ohmybash/tarball/main`
   - Saves to temporary file: `/tmp/XXXXX`
   - Uses curl (macOS) or wget (Ubuntu/Raspberry Pi OS)

2. **Choose Installation Directory**
   - Default location: `$HOME/projects/dotfiles`
   - Interactive mode: Prompts user for confirmation or alternative location
   - Non-interactive mode (`-y` flag): Uses default, overwrites if exists
   - Checks if directory already exists and prompts for overwrite confirmation

3. **Create Directory**
   - Creates the chosen directory: `mkdir -p $dotfilesDirectory`
   - Ensures parent directories exist

4. **Extract Archive**
   - Extracts tarball to chosen directory
   - Uses: `tar --extract --gzip --file <archive> --strip-components 1 --directory <outputDir>`
   - `--strip-components 1` removes the top-level GitHub directory from the archive

5. **Cleanup**
   - Removes temporary tarball file
   - Changes to dotfiles directory: `cd $dotfilesDirectory/src/os`

6. **Verify OS Version**
   - Checks OS type (macOS, ubuntu, raspbian)
   - Verifies minimum version:
     - macOS: 10.10+
     - Ubuntu: 20.04+
     - Raspberry Pi OS: 10+
   - Exits if unsupported

### Backup Original Files

**Before** creating symlinks, the setup process backs up existing Bash configuration files:

**What Gets Backed Up:**
- All files matching: `$HOME/.bash*`
- Examples: `.bashrc`, `.bash_profile`, `.bash_aliases`, `.bash_logout`

**Backup Process:**
1. Finds all `.bash*` files in home directory (max depth 1, files only)
2. Skips files already ending in `-original` (preserves existing backups)
3. Creates backup with `-original` suffix: `cp $file ${file}-original`
4. Only creates backup if it doesn't already exist (idempotent)

**Examples:**
- `~/.bashrc` → `~/.bashrc-original`
- `~/.bash_profile` → `~/.bash_profile-original`
- `~/.bash_aliases` → `~/.bash_aliases-original`

**Important:** Backups are created ONCE and preserved on subsequent runs. This ensures you can always revert to your original configuration.

### Create Symbolic Links

After backup, the setup creates symlinks from the dotfiles repository to the home directory:

**Files That Get Symlinked:**
- **Shell:** bash_aliases, bash_autocompletion, bash_exports, bash_functions, bash_init, bash_logout, bash_options, bash_profile, bash_prompt, bashrc, curlrc, inputrc
- **Git:** gitattributes, gitconfig, gitignore
- **tmux:** tmux.conf
- **Vim:** vim/ (directory), vimrc

**Symlink Process:**
1. Determines OS-specific shell files if available (e.g., `shell/macos/`, `shell/ubuntu-24-svr/`)
2. For each file in the list:
   - Source: `$dotfilesDirectory/src/<category>/<file>`
   - Target: `$HOME/.<file>` (adds leading dot)
3. Checks if target already exists:
   - If doesn't exist: Creates symlink immediately
   - If exists and is already correct symlink: Reports success, no action
   - If exists and is different: Prompts for overwrite confirmation (interactive mode)
4. Creates symlink: `ln -fs $sourceFile $targetFile`

**Example Symlinks:**
- `~/projects/dotfiles/src/shell/bashrc` → `~/.bashrc`
- `~/projects/dotfiles/src/git/gitconfig` → `~/.gitconfig`
- `~/projects/dotfiles/src/vim/vimrc` → `~/.vimrc`

### Create Local Configuration Files

The setup creates empty/template local configuration files that are NOT tracked in Git:

**Files Created:**

1. **`~/.bash.local`**
   - Purpose: User-specific Bash configurations
   - Content: Template with PATH additions pointing to dotfiles bin directory
   - Example:
     ```bash
     #!/bin/bash

     # Set PATH additions.
     PATH="/path/to/dotfiles/bin/:$PATH"
     export PATH
     ```

2. **`~/.gitconfig.local`**
   - Purpose: User-specific Git settings (credentials, signing keys)
   - Content: Template with placeholders for user name, email, GPG signing
   - Example:
     ```gitconfig
     [commit]
         # gpgsign = true

     [user]
         name =
         email =
         # signingkey =
     ```

3. **`~/.vimrc.local`**
   - Purpose: User-specific Vim customizations
   - Content: Empty file (user adds customizations as needed)

**Important:** These `.local` files are sourced by the main dotfiles but are NOT committed to the repository. This allows user-specific settings without polluting the shared dotfiles.

### Initialize Git Repository (Workstation/macOS Only)

For workstation and macOS environments, the setup initializes a Git repository in the dotfiles directory:

**When This Happens:**
- OS is macOS OR
- OS ends with `-wks` (workstation edition)
- Git is installed
- Remote origin URL is not already set correctly

**Git Initialization:**
1. Changes to dotfiles root directory
2. Runs: `git init`
3. Adds remote: `git remote add origin git@github.com:fredlackey/dotfiles-ohmybash.git`

**Purpose:** Allows tracking local dotfiles changes and pulling updates from the repository.

**Note:** This does NOT happen on server editions (`-svr`) to keep servers lean.

### Summary of Phase 0

Before any OS prerequisites are installed, the setup process:

1. ✅ Downloads dotfiles tarball from GitHub
2. ✅ Prompts for installation directory (default: `~/projects/dotfiles`)
3. ✅ Creates directory and extracts archive
4. ✅ Verifies OS version is supported
5. ✅ Backs up existing `.bash*` files with `-original` suffix
6. ✅ Creates symlinks from dotfiles to home directory
7. ✅ Creates `.local` configuration files for user customization
8. ✅ Initializes Git repository (workstation/macOS only)

**After Phase 0 completes, the system is ready for Phase 1: Installing OS prerequisites.**

## Phase 1: Universal Prerequisites (All Operating Systems)

These tools must be present on ALL operating systems. Phase 0 (dotfiles download) requires at minimum Bash and one download tool (curl OR wget), but both download tools should be installed early in Phase 1.

### 1. Bash Shell
- **Requirement:** System-provided Bash (any version)
- **Purpose:** Execute all dotfiles scripts
- **Verification:** `bash --version`
- **Notes:**
  - Pre-installed on macOS and Linux
  - macOS ships with Bash 3.2 (2007) - this is sufficient
  - Ubuntu/Raspberry Pi ship with Bash 5.x - this is sufficient
  - **DO NOT install or upgrade Bash** - use the OS-provided version
  - Oh My Bash works with all Bash versions (3.2+)

### 2. Core Utilities
- **Requirement:** Basic UNIX utilities (tar, gzip, mkdir, ln, cp, rm, etc.)
- **Purpose:** File operations, archive extraction, symlink creation
- **Verification:** `command -v tar && command -v gzip`
- **Notes:** Pre-installed on all Unix-like systems

### 3. Download Tools
- **Requirement:** curl AND wget (both required)
- **Purpose:** Download files, scripts, and GPG keys throughout system lifecycle
- **Verification:** `command -v curl && command -v wget`
- **Notes:**
  - macOS: curl is pre-installed, wget must be installed via Homebrew
  - Ubuntu: wget is typically pre-installed, curl is installed early in setup
  - Raspberry Pi: Both must be installed
  - BOTH tools are used extensively:
    - curl: Homebrew installation, Docker GPG keys, Tailscale, Oh My Bash
    - wget: GPG key downloads, repository setup, legacy compatibility
  - For initial bootstrap, only ONE is needed, but BOTH should be installed early

### 4. Git
- **Requirement:** Git 2.0+
- **Purpose:**
  - Clone NVM repository
  - Initialize dotfiles repository
  - Download Vim plugins via minpac
- **Verification:** `git --version`
- **Installation:** See OS-specific sections below
- **Notes:** While Git is installed by the dotfiles, it's needed early in the process

## Phase 2: macOS Prerequisites

### Installation Order

1. **Xcode Command Line Tools** (MUST BE FIRST)
2. **Homebrew** (MUST BE SECOND)
3. **wget** (MUST BE THIRD)

### 1. Xcode Command Line Tools
- **Requirement:** Latest version for your macOS
- **Purpose:**
  - Provides essential development tools (Git, make, compilers)
  - Required by Homebrew
  - Required to build any software from source
- **Installation:**
  ```bash
  xcode-select --install
  ```
- **Verification:** `xcode-select --print-path`
- **Notes:**
  - This is the FIRST thing that must be installed on macOS
  - Interactive prompt will appear - user must approve
  - Installation takes 5-15 minutes depending on connection
  - Includes: Git, make, gcc, clang, and other build tools

### 2. Homebrew
- **Requirement:** Latest Homebrew
- **Purpose:**
  - Primary package manager for macOS
  - Required to install all other packages (Vim, tmux, wget, etc.)
- **Installation:**
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```
- **Post-Installation:**
  ```bash
  # Opt-out of analytics
  brew analytics off

  # Update package index
  brew update

  # Upgrade any existing packages
  brew upgrade
  ```
- **Verification:** `brew --version`
- **Notes:**
  - Requires Xcode Command Line Tools to be installed first
  - Will prompt for sudo password
  - Installation location:
    - Intel Macs: `/usr/local`
    - Apple Silicon Macs: `/opt/homebrew`

### 3. Wget
- **Requirement:** wget command-line tool
- **Purpose:** Download files and GPG keys (curl alone is not sufficient)
- **Installation:**
  ```bash
  brew install wget
  ```
- **Verification:** `command -v wget`
- **Notes:**
  - macOS ships with curl but NOT wget
  - Both curl and wget are used throughout the system
  - Should be installed immediately after Homebrew

### macOS Prerequisite Summary

**Required:**
- Xcode Command Line Tools
- Homebrew
- wget

**Not Installed (Legacy Only):**
- Xcode.app - The full IDE was installed in the legacy system but is NOT needed for this dotfiles setup. Only required for iOS/macOS app development.

**Installation Script Order:**
```bash
# 1. Install Xcode Command Line Tools
xcode-select --install
# Wait for completion...

# 2. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. Configure Homebrew
brew analytics off
brew update
brew upgrade

# 4. Install wget (macOS doesn't include it by default)
brew install wget

# 5. NOW dotfiles can be installed

# NOTE: Xcode.app (the full IDE) is NOT installed
# The legacy system installed it, but it's not needed unless you're doing iOS/macOS development
```

## Phase 2: Ubuntu Prerequisites

### Installation Order

1. **apt update** (MUST BE FIRST)
2. **build-essential** (MUST BE SECOND)
3. **curl/wget** (usually pre-installed)
4. **git** (via apt)

### 1. Update Package Index
- **Requirement:** Latest package lists
- **Purpose:** Ensure package manager has current package information
- **Installation:**
  ```bash
  sudo apt-get update -qqy
  ```
- **Notes:**
  - Must be run BEFORE installing any packages
  - Should be run as first command on fresh system

### 2. Build Essentials
- **Requirement:** build-essential package
- **Purpose:**
  - Provides compilers (gcc, g++, make)
  - Required to build software from source
  - Required for NVM and native Node.js modules
- **Installation:**
  ```bash
  sudo apt-get install -qqy build-essential
  ```
- **Includes:**
  - gcc (GNU C compiler)
  - g++ (GNU C++ compiler)
  - make (build automation)
  - libc6-dev (C library development files)
  - dpkg-dev (Debian package development tools)
- **Verification:** `gcc --version && make --version`
- **Notes:**
  - This is the FIRST package that must be installed on Ubuntu
  - Required before any other software installation

### 3. Debian Archive Keyring
- **Requirement:** debian-archive-keyring package
- **Purpose:** GnuPG archive keys for Debian/Ubuntu repositories
- **Installation:**
  ```bash
  sudo apt-get install -qqy debian-archive-keyring
  ```
- **Notes:**
  - Ensures secure package installation
  - Should be installed early in the process

### 4. Git
- **Requirement:** Git from apt repository
- **Purpose:** Clone repositories, download Vim plugins
- **Installation:**
  ```bash
  sudo apt-get install -qqy git
  ```
- **Verification:** `git --version`

### 5. Curl and Wget
- **Requirement:** Both curl AND wget
- **Purpose:** Download files, scripts, and GPG keys
- **Installation:**
  ```bash
  sudo apt-get install -qqy curl wget
  ```
- **Notes:**
  - wget is typically pre-installed on Ubuntu
  - curl must be installed explicitly
  - Both are used extensively throughout the system

### Ubuntu Prerequisite Summary

**Minimum Required:**
- apt update (run first)
- build-essential
- debian-archive-keyring
- git
- curl AND wget (both required)

**Installation Script Order:**
```bash
# 1. Update package index
sudo apt-get update -qqy

# 2. Install build essentials
sudo apt-get install -qqy build-essential

# 3. Install Debian keyring
sudo apt-get install -qqy debian-archive-keyring

# 4. Install Git
sudo apt-get install -qqy git

# 5. Install BOTH download tools (curl and wget)
sudo apt-get install -qqy curl wget

# 6. NOW dotfiles can be installed
```

## Phase 2: Raspberry Pi OS Prerequisites

Raspberry Pi OS uses the same prerequisites as Ubuntu (Debian-based), with some additional considerations.

### Installation Order

1. **apt update** (MUST BE FIRST)
2. **build-essential** (MUST BE SECOND)
3. **Additional build tools** (Python development headers, etc.)
4. **git**

### 1. Update Package Index
- **Same as Ubuntu:**
  ```bash
  sudo apt-get update -qqy
  ```

### 2. Build Essentials
- **Same as Ubuntu:**
  ```bash
  sudo apt-get install -qqy build-essential
  ```

### 3. Additional Build Tools
- **Requirement:** Extended build tools for ARM architecture
- **Purpose:** Build software optimized for ARM processors
- **Installation:**
  ```bash
  sudo apt-get install -qqy \
    build-essential \
    debian-archive-keyring \
    python3-dev \
    python3-pip \
    make \
    cmake \
    gcc \
    g++
  ```
- **Notes:**
  - Python development headers needed for some packages
  - cmake often required for ARM-specific builds

### 4. Debian Archive Keyring
- **Same as Ubuntu:**
  ```bash
  sudo apt-get install -qqy debian-archive-keyring
  ```

### 5. Git
- **Same as Ubuntu:**
  ```bash
  sudo apt-get install -qqy git
  ```

### 6. Curl and Wget
- **Requirement:** Both curl AND wget
- **Installation:**
  ```bash
  sudo apt-get install -qqy curl wget
  ```
- **Notes:** Both tools are explicitly installed on Raspberry Pi OS in the legacy system

### Raspberry Pi OS Prerequisite Summary

**Minimum Required:**
- apt update (run first)
- build-essential
- debian-archive-keyring
- python3-dev and python3-pip (ARM-specific needs)
- make, cmake, gcc, g++ (extended build tools)
- git
- curl AND wget (both required)

**Installation Script Order:**
```bash
# 1. Update package index
sudo apt-get update -qqy

# 2. Install comprehensive build tools
sudo apt-get install -qqy \
  build-essential \
  debian-archive-keyring \
  python3-dev \
  python3-pip \
  make \
  cmake \
  gcc \
  g++

# 3. Install Git
sudo apt-get install -qqy git

# 4. Install BOTH download tools (curl and wget)
sudo apt-get install -qqy curl wget

# 5. NOW dotfiles can be installed
```

## Sudo Access

### All Operating Systems
- **Requirement:** User must have sudo privileges
- **Purpose:** Install system packages and modify system files
- **Verification:** `sudo -v`
- **Notes:**
  - Setup script requests sudo upfront and keeps it alive
  - Some operations require root access (package installation, symlink creation in /usr/local, etc.)
  - Interactive prompts may appear for sudo password

## Minimum System Requirements

### macOS
- **OS Version:** macOS 10.10 (Yosemite) or later
- **Recommended:** macOS 14 (Sonoma) or macOS 15 (Sequoia)
- **Disk Space:** 10+ GB free (for Xcode and Homebrew packages)
- **RAM:** 4 GB minimum, 8 GB recommended

### Ubuntu
- **OS Version:** Ubuntu 20.04 LTS or later
- **Recommended:** Ubuntu 24.04 LTS
- **Editions:** Server or Desktop (Workstation)
- **Disk Space:** 5+ GB free
- **RAM:** 2 GB minimum, 4 GB recommended

### Raspberry Pi OS
- **OS Version:** Raspberry Pi OS 10 (Buster) or later
- **Recommended:** Raspberry Pi OS 12 (Bookworm)
- **Architecture:** ARM (armhf or arm64)
- **Disk Space:** 8+ GB SD card
- **RAM:** 1 GB minimum, 2 GB+ recommended

## Prerequisites vs. Installations

**Prerequisites** are tools that must exist BEFORE dotfiles installation:
- Package managers (Homebrew, apt)
- Build tools (Xcode Command Line Tools, build-essential)
- Version control (Git)
- Download utilities (curl/wget)

**Installations** are tools installed BY the dotfiles system:
- Oh My Bash
- NVM and Node.js
- Vim (with plugins)
- tmux
- Docker
- VS Code
- Application packages
- Development tools

## Verification Checklist

Before running the dotfiles setup script, verify prerequisites are met:

### macOS Checklist
```bash
# Check Xcode Command Line Tools
xcode-select --print-path

# Check Homebrew
brew --version

# Check BOTH download tools
command -v curl && command -v wget

# Check sudo access
sudo -v
```

### Ubuntu/Raspberry Pi Checklist
```bash
# Check build essentials
gcc --version && make --version

# Check Git
git --version

# Check download tools
command -v curl && command -v wget

# Check sudo access
sudo -v
```

## Common Issues

### macOS

**Issue:** "xcode-select: error: command line tools are not installed"
- **Solution:** Run `xcode-select --install` and wait for completion

**Issue:** "Homebrew is not installed"
- **Solution:** Install Xcode Command Line Tools first, then install Homebrew

**Issue:** "brew command not found"
- **Solution:** Add Homebrew to PATH or restart terminal
  - Intel: Add `/usr/local/bin` to PATH
  - Apple Silicon: Add `/opt/homebrew/bin` to PATH

### Ubuntu/Raspberry Pi

**Issue:** "make: command not found" or "gcc: command not found"
- **Solution:** Install build-essential: `sudo apt-get install build-essential`

**Issue:** "Unable to locate package"
- **Solution:** Run `sudo apt-get update` first

**Issue:** "E: Could not get lock /var/lib/apt/lists/lock"
- **Solution:** Another package manager process is running. Wait or kill it.

## Automated Prerequisite Installation

The dotfiles setup script (`src/setup.sh`) will check for and install prerequisites automatically, but the following must be done manually first:

### macOS Manual Steps
1. Install Xcode Command Line Tools (user approval required)
2. Optionally install Xcode.app from Mac App Store

### Ubuntu/Raspberry Pi Manual Steps
1. Ensure sudo access (no automated way to grant this)
2. Run `sudo apt-get update` (setup script does this, but good practice)

## Summary

**Prerequisites are the foundation.** Without them:
- Package managers cannot function
- Software cannot be compiled from source
- Scripts cannot download files
- Dotfiles cannot be installed

Always install prerequisites in the correct order for each OS before attempting to run the dotfiles setup script.

---

**Related Documentation:**
- `README.md` - Project overview and installation
- `docs/INSTALLS.md` - Complete package installation reference
- `docs/FILE_STRUCTURE.md` - Directory organization
- `ai-docs/UTILITY_FUNCTIONS.md` - Helper functions reference
