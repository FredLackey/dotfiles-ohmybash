# Legacy Dotfiles Setup Process

This document describes the step-by-step process that the legacy dotfiles system (`_legacy/`) follows when executing the setup. The process is documented in phases for clarity, though the legacy implementation does not explicitly identify phases.

## Entry Point

**File:** `_legacy/src/os/setup.sh`

**Execution Modes:**
- Interactive mode: `./setup.sh` (asks for user confirmation)
- Non-interactive mode: `./setup.sh -y` or `./setup.sh --yes` (auto-confirms all prompts)

**Global Configuration:**
- Repository: `fredlackey/dotfiles`
- Default installation directory: `$HOME/projects/dotfiles`
- Git origin: `git@github.com:fredlackey/dotfiles.git`

---

## PHASE 0: Bootstrap and Prerequisites

This phase handles the initial setup before any installations begin. It downloads the repository, verifies the OS, and prepares the environment.

### Step 0.1: Change to Script Directory

**File:** `_legacy/src/os/setup.sh` (line 239)

**Action:**
- Changes to the directory containing setup.sh
- Ensures all relative paths work correctly

### Step 0.2: Load or Download Utilities

**File:** `_legacy/src/os/setup.sh` (lines 246-250)

**Action:**
- Checks if `utils.sh` exists locally
- If exists: Sources it directly
- If not exists: Downloads utils.sh from GitHub raw URL and sources it
- Downloaded via `download_utils()` function to temporary file

**Purpose:** Makes utility functions available for setup process

### Step 0.3: Verify Operating System

**File:** `_legacy/src/os/setup.sh` (lines 257-258)

**Action:**
- Calls `verify_os()` function
- Detects OS via `get_os()`: returns "macos", "ubuntu", or "raspbian"
- Gets OS version via `get_os_version()`
- Compares against minimum requirements:
  - macOS: 10.10 (Yosemite)
  - Ubuntu: 20.04 LTS
  - Raspberry Pi OS: 10 (Buster)
- Exits if OS unsupported or version too old

### Step 0.4: Parse Arguments

**File:** `_legacy/src/os/setup.sh` (lines 262-263)

**Action:**
- Checks for `-y` or `--yes` flags via `skip_questions()`
- Sets `skipQuestions=true` if found
- Controls whether to prompt user for confirmations

### Step 0.5: Request Sudo Access

**File:** `_legacy/src/os/setup.sh` (line 267)

**Action:**
- Calls `ask_for_sudo()` function
- Prompts for sudo password upfront
- Starts background process to keep sudo alive every 60 seconds
- Prevents repeated password prompts during installation

### Step 0.6: Download Dotfiles (If Remote Execution)

**File:** `_legacy/src/os/setup.sh` (lines 275-276)

**Condition:** Only runs if script was NOT executed locally (checks if path contains "setup.sh")

**Action via `download_dotfiles()` function:**

1. **Download Archive:**
   - Creates temporary file: `mktemp /tmp/XXXXX`
   - Downloads tarball from GitHub: `https://github.com/fredlackey/dotfiles/tarball/main`
   - Uses `download()` function (tries curl first, falls back to wget)

2. **Prompt for Installation Directory:**
   - Interactive mode:
     - Asks: "Do you want to store the dotfiles in '$HOME/projects/dotfiles'?"
     - If no: Prompts for alternative directory path
     - If directory exists: Asks to overwrite or choose new location
   - Non-interactive mode (`-y` flag):
     - Uses default directory `$HOME/projects/dotfiles`
     - Removes existing directory without prompting

3. **Create Directory:**
   - Executes: `mkdir -p "$dotfilesDirectory"`
   - Creates parent directories if needed

4. **Extract Archive:**
   - Calls `extract()` function
   - Executes: `tar --extract --gzip --file <archive> --strip-components 1 --directory <outputDir>`
   - `--strip-components 1` removes top-level GitHub directory wrapper

5. **Cleanup:**
   - Removes temporary tarball file
   - Changes directory to `$dotfilesDirectory/src/os`

**Note:** If running locally (script path contains "setup.sh"), this entire step is skipped.

---

## PHASE 1: File System Setup

This phase backs up existing files and creates the dotfiles structure in the user's home directory.

### Step 1.1: Backup Original Bash Files

**File:** `_legacy/src/os/create_symbolic_links.sh` (executed via line 280 of setup.sh)

**Action via `backup_bash_files()` function:**

1. **Find Bash Files:**
   - Searches: `find "$HOME" -maxdepth 1 -name ".bash*" -type f`
   - Finds all files matching `.bash*` pattern (depth 1, files only)
   - Examples: `.bashrc`, `.bash_profile`, `.bash_aliases`, `.bash_logout`, `.bash_history`

2. **Create Backups:**
   - Skips files already ending in `-original` (preserves existing backups)
   - For each file without backup:
     - Checks if `${file}-original` exists
     - If not exists: Creates backup via `cp $file ${file}-original`
     - If exists: Reports success (no action)

**Idempotency:** Safe to run multiple times - preserves original backups

**Examples:**
- `~/.bashrc` ’ `~/.bashrc-original`
- `~/.bash_profile` ’ `~/.bash_profile-original`

### Step 1.2: Create Symbolic Links

**File:** `_legacy/src/os/create_symbolic_links.sh` (same file, continues from backup)

**Action via `create_symlinks()` function:**

1. **Determine OS-Specific Shell Path:**
   - Calls `get_os_name()` to get detailed OS identifier
   - Examples: "macos", "ubuntu-24-svr", "ubuntu-24-wks", "raspberry-pi-os"
   - Checks if OS-specific shell directory exists: `../shell/$os_name`
   - If exists: Uses OS-specific path (e.g., `shell/macos`, `shell/ubuntu-24-svr`)
   - If not: Uses generic `shell` path

2. **Files to Symlink (Array):**
   - **Shell files:** bash_aliases, bash_autocompletion, bash_exports, bash_functions, bash_init, bash_logout, bash_options, bash_profile, bash_prompt, bashrc, curlrc, inputrc
   - **Git files:** gitattributes, gitconfig, gitignore
   - **tmux files:** tmux.conf
   - **Vim files:** vim/ (directory), vimrc

3. **Create Symlinks:**
   - For each file in array:
     - **Source path:** `$dotfilesDirectory/src/<category>/<file>`
     - **Target path:** `$HOME/.<file>` (adds leading dot)
     - Extracts filename from path using sed

   - **Link creation logic:**
     - If target doesn't exist OR skip questions mode: Creates symlink immediately
     - If target exists and is already correct symlink: Reports success (no action)
     - If target exists and is different:
       - Interactive mode: Prompts "do you want to overwrite it?"
       - User says yes: Removes target and creates symlink
       - User says no: Skips (reports error)
     - Creates link: `ln -fs $sourceFile $targetFile`

**Example Symlinks:**
- `~/projects/dotfiles/src/shell/bashrc` ’ `~/.bashrc`
- `~/projects/dotfiles/src/git/gitconfig` ’ `~/.gitconfig`
- `~/projects/dotfiles/src/vim/vimrc` ’ `~/.vimrc`

### Step 1.3: Create Local Configuration Files

**File:** `_legacy/src/os/create_local_config_files.sh` (executed via line 284 of setup.sh)

**Purpose:** Create user-specific config files that are NOT tracked in Git

#### Create ~/.bash.local

**Action via `create_bash_local()` function:**

1. Checks if `~/.bash.local` exists or is empty
2. If doesn't exist or empty:
   - Determines dotfiles bin directory path
   - Creates file with template:
     - Shebang: `#!/bin/bash`
     - Comment header
     - PATH addition: `PATH="/path/to/dotfiles/bin/:$PATH"`
     - Export PATH

**Purpose:** User-specific Bash configurations and PATH additions

#### Create ~/.gitconfig.local

**Action via `create_gitconfig_local()` function:**

1. Checks if `~/.gitconfig.local` exists or is empty
2. If doesn't exist or empty:
   - Creates file with template:
     - `[commit]` section with commented-out `gpgsign = true`
     - `[user]` section with empty name and email fields
     - Commented-out `signingkey` field

**Purpose:** User-specific Git settings (credentials, GPG keys)

#### Create ~/.vimrc.local

**Action via `create_vimrc_local()` function:**

1. Checks if `~/.vimrc.local` exists
2. If doesn't exist:
   - Creates empty file: `printf "" >> "$FILE_PATH"`

**Purpose:** User-specific Vim customizations

---

## PHASE 2: Software Installation

This phase installs all required software, packages, and tools. The installation process is OS-specific.

### Step 2.1: Execute OS-Specific Installation Script

**File:** `_legacy/src/os/installs/main.sh` (executed via line 288 of setup.sh)

**Action:**
- Sources `../utils.sh` to load utility functions
- Calls OS-specific main.sh: `./$(get_os_name)/main.sh`
- `get_os_name()` returns detailed OS identifier

**OS-Specific Scripts:**
- macOS: `_legacy/src/os/installs/macos/main.sh`
- Ubuntu 24 Server: `_legacy/src/os/installs/ubuntu-24-svr/main.sh`
- Ubuntu 24 Workstation: `_legacy/src/os/installs/ubuntu-24-wks/main.sh`
- Ubuntu 22 Server: `_legacy/src/os/installs/ubuntu-22-svr/main.sh`
- Ubuntu 23 Server: `_legacy/src/os/installs/ubuntu-23-svr/main.sh`
- Ubuntu 20 Server: `_legacy/src/os/installs/ubuntu-20-svr/main.sh`
- Raspberry Pi OS: `_legacy/src/os/installs/raspberry-pi-os/main.sh`
- Ubuntu Original: `_legacy/src/os/installs/ubuntu-original/main.sh`

### Step 2.2: macOS Installation Process

**File:** `_legacy/src/os/installs/macos/main.sh`

**Execution Order:**

1. **Sources Utilities:**
   - `../../utils.sh` - Core utilities
   - `./utils.sh` - Homebrew-specific utilities

2. **Executes Installation Scripts (in order):**
   - `./xcode.sh` - Xcode Command Line Tools (prerequisite)
   - `./homebrew.sh` - Homebrew package manager
   - `./bash.sh` - Bash (NOTE: Legacy installs Bash via Homebrew, new system should NOT)
   - `./git.sh` - Git
   - `./../nvm.sh` - **Shared script** - NVM and Node.js 22
   - `./browsers.sh` - Chrome, Chrome Canary, Safari Tech Preview
   - `./compression_tools.sh` - Compression utilities
   - `./gpg.sh` - GPG tools
   - `./image_tools.sh` - Image processing tools
   - `./misc.sh` - Miscellaneous applications
   - `./misc_tools.sh` - Miscellaneous command-line tools
   - `./../npm.sh` - **Shared script** - npm update
   - `./tmux.sh` - tmux
   - `./video_tools.sh` - Video processing tools
   - `./../vim.sh` - **Shared script** - Vim with minpac plugins
   - `./vscode.sh` - Visual Studio Code
   - `./web_font_tools.sh` - Web font conversion tools

**Note:** Scripts prefixed with `../` are shared across all OSes and located in `_legacy/src/os/installs/`

### Step 2.3: Ubuntu Server Installation Process

**File:** `_legacy/src/os/installs/ubuntu-24-svr/main.sh` (similar for 20, 22, 23)

**Execution Order:**

1. **Sources Utilities:**
   - `../../utils.sh` - Core utilities
   - `./utils.sh` - APT-specific utilities

2. **System Updates:**
   - `update` - Runs `apt-get update`
   - `upgrade` - Runs `apt-get upgrade`

3. **Executes Installation Scripts (in order):**
   - `./build-essentials.sh` - build-essential package
   - `./git.sh` - Git
   - `./../nvm.sh` - **Shared script** - NVM and Node.js 22
   - `./browsers.sh` - Text-based browsers (Raspberry Pi OS only)
   - `./compression_tools.sh` - Compression utilities
   - `./image_tools.sh` - Image processing tools
   - `./misc.sh` - System utilities
   - `./misc_tools.sh` - Additional command-line tools
   - `./docker.sh` - Docker CE with Compose and Buildx
   - `./../npm.sh` - **Shared script** - npm update
   - `./tmux.sh` - tmux
   - `./../vim.sh` - **Shared script** - Vim with minpac plugins

4. **Cleanup:**
   - `./cleanup.sh` - Runs `autoremove` and `clean`

### Step 2.4: Ubuntu Workstation Installation Process

**File:** `_legacy/src/os/installs/ubuntu-24-wks/main.sh`

**Same as Ubuntu Server with additions:**
- Includes GUI applications
- Installs Chromium browser instead of text-based browsers

### Step 2.5: Raspberry Pi OS Installation Process

**File:** `_legacy/src/os/installs/raspberry-pi-os/main.sh`

**Similar to Ubuntu Server with ARM-specific considerations:**
- Additional build tools (cmake, python3-dev, python3-pip)
- Text-based browsers (lynx, links, w3m)
- System monitoring tools (iotop, iftop, nethogs, nload)
- Raspberry Pi specific utilities (raspi-config)

### Shared Installation Scripts

These scripts are located in `_legacy/src/os/installs/` and used across all OSes:

#### NVM Installation (`nvm.sh`)

**Actions:**
1. **Check if NVM exists:**
   - Directory: `$HOME/.nvm`
   - If not exists: Clone NVM repo from GitHub
   - If exists: Update to latest version via git

2. **Add NVM configurations:**
   - Appends NVM config to `~/.bash.local`:
     - `export NVM_DIR="$HOME/.nvm"`
     - Source nvm.sh script
     - Source bash_completion
   - Sources the updated config

3. **Install Node.js 22:**
   - Executes: `nvm install 22`
   - Sets as default version

#### Vim Installation (`vim.sh`)

**Actions:**
1. **Call OS-specific Vim installation:**
   - Executes: `./$(get_os_name)/vim.sh`
   - macOS: Installs Vim via Homebrew
   - Ubuntu: Installs vim package via apt

2. **Install Vim plugins:**
   - Removes existing pack directory: `~/.vim/pack`
   - Clones minpac plugin manager from GitHub
   - Executes Vim command: `vim +PluginsSetup`
   - minpac installs all configured plugins

#### npm Update (`npm.sh`)

**Actions:**
1. Sources `~/.bash.local` to load NVM/Node
2. Executes: `npm install --global --silent npm`
3. Updates npm to latest version globally

---

## PHASE 3: System Preferences Configuration

This phase configures OS-specific system preferences and settings.

### Step 3.1: Execute OS-Specific Preferences Script

**File:** `_legacy/src/os/preferences/main.sh` (executed via line 292 of setup.sh)

**Action:**
- Sources `../utils.sh` to load utility functions
- Calls OS-specific main.sh: `./$(get_os_name)/main.sh`

**OS-Specific Scripts:**
- macOS: `_legacy/src/os/preferences/macos/main.sh`
- Ubuntu 24 Server: `_legacy/src/os/preferences/ubuntu-24-svr/main.sh`
- Ubuntu 24 Workstation: `_legacy/src/os/preferences/ubuntu-24-wks/main.sh`
- Other Ubuntu versions: Similar pattern
- Raspberry Pi OS: `_legacy/src/os/preferences/raspberry-pi-os/main.sh`

### Step 3.2: macOS Preferences Configuration

**File:** `_legacy/src/os/preferences/macos/main.sh`

**Execution Order:**

1. **Close System Preferences:**
   - Executes: `./close_system_preferences_panes.applescript`
   - Purpose: Prevents conflicts with preferences being changed

2. **Configure Applications and System Settings (in order):**
   - `./app_store.sh` - Mac App Store preferences
   - `./chrome.sh` - Google Chrome settings
   - `./dock.sh` - Dock configuration
   - `./finder.sh` - Finder preferences
   - `./firefox.sh` - Firefox settings
   - `./keyboard.sh` - Keyboard settings
   - `./language_and_region.sh` - Language and region settings
   - `./maps.sh` - Maps preferences
   - `./photos.sh` - Photos app settings
   - `./safari.sh` - Safari preferences
   - `./security_and_privacy.sh` - Security settings
   - `./terminal.sh` - Terminal preferences
   - `./textedit.sh` - TextEdit settings
   - `./trackpad.sh` - Trackpad configuration
   - `./ui_and_ux.sh` - UI and UX preferences

**Method:** Uses `defaults write` commands to modify plist files

### Step 3.3: Ubuntu Server Preferences Configuration

**File:** `_legacy/src/os/preferences/ubuntu-24-svr/main.sh`

**Execution Order:**

1. **Configure Settings (in order):**
   - `./privacy.sh` - Privacy settings
   - `./terminal.sh` - Terminal preferences
   - `./ui_and_ux.sh` - UI and UX settings

**Method:** Minimal configuration for server environment (no GUI applications)

### Step 3.4: Ubuntu Workstation Preferences Configuration

**File:** `_legacy/src/os/preferences/ubuntu-24-wks/main.sh`

**More extensive than server:**
- GNOME desktop settings
- Application preferences
- Keyboard shortcuts
- Appearance settings

**Method:** Uses `gsettings` and `dconf` commands

### Step 3.5: Raspberry Pi OS Preferences Configuration

**File:** `_legacy/src/os/preferences/raspberry-pi-os/main.sh`

**Similar to Ubuntu with ARM-specific adjustments**

---

## PHASE 4: Git Repository Initialization (Workstation/macOS Only)

This phase initializes the dotfiles directory as a Git repository and optionally updates content.

### Step 4.1: Check Environment Type

**File:** `_legacy/src/os/setup.sh` (lines 297-298)

**Condition:**
- Only runs for workstation and macOS environments
- Checks: `if [[ "$os_name" == *"-wks" ]] || [[ "$os_name" == "macos" ]]`
- Server editions (`-svr`) skip this phase

**Rationale:** Keep servers lean without Git repository overhead

### Step 4.2: Verify Git is Installed

**File:** `_legacy/src/os/setup.sh` (line 300)

**Action:**
- Calls `cmd_exists "git"`
- Only proceeds if Git command is available

### Step 4.3: Check Git Remote

**File:** `_legacy/src/os/setup.sh` (lines 302-304)

**Action:**
- Gets current Git remote origin: `git config --get remote.origin.url`
- Compares to expected: `git@github.com:fredlackey/dotfiles.git`
- If different or not set: Initialize Git repository

### Step 4.4: Initialize Git Repository

**File:** `_legacy/src/os/initialize_git_repository.sh` (executed if needed)

**Action via `initialize_git_repository()` function:**

1. **Validate Origin URL:**
   - Checks that origin URL parameter was provided
   - Exits with error if missing

2. **Check if Already Git Repository:**
   - Calls `is_git_repository()` function
   - If NOT a repository: Proceed with initialization

3. **Initialize and Set Remote:**
   - Changes to dotfiles root directory: `cd ../../`
   - Executes: `git init && git remote add origin <git_origin>`
   - Sets up repository for tracking changes

### Step 4.5: Update Content (Interactive Only)

**File:** `_legacy/src/os/update_content.sh` (executed via lines 308-310 of setup.sh)

**Condition:** Only runs in interactive mode (not with `-y` flag)

**Action:**

1. **Verify GitHub SSH Access:**
   - Tests: `ssh -T git@github.com`
   - If fails (exit code ` 1): Runs `./set_github_ssh_key.sh`
   - Purpose: Ensure SSH key is set up for Git operations

2. **Prompt to Update:**
   - Asks: "Do you want to update the content from the 'dotfiles' directory?"
   - If user confirms yes:
     - Fetches all remotes: `git fetch --all`
     - Hard resets to origin/main: `git reset --hard origin/main`
     - Checks out main branch: `git checkout main`
     - Cleans untracked files: `git clean -fd`

**Purpose:** Synchronize local dotfiles with remote repository

---

## PHASE 5: System Restart (Interactive Only)

Final phase that optionally restarts the system to apply all changes.

### Step 5.1: Prompt for Restart

**File:** `_legacy/src/os/restart.sh` (executed via lines 318-320 of setup.sh)

**Condition:** Only runs in interactive mode (not with `-y` flag)

**Action via main() function:**

1. **Display Prompt:**
   - Prints: "Do you want to restart?"
   - Waits for user confirmation

2. **Restart System:**
   - If user answers yes:
     - Executes: `sudo shutdown -r now`
     - System restarts immediately

**Rationale:** Some system preferences and installations require restart to take full effect

---

## Process Flow Summary

```
PHASE 0: Bootstrap and Prerequisites
  Load or download utilities
  Verify OS and version
  Parse arguments (-y flag)
  Request sudo access
  Download dotfiles (if remote execution)

PHASE 1: File System Setup
  Backup existing .bash* files
  Create symbolic links for dotfiles
  Create local configuration files (.bash.local, .gitconfig.local, .vimrc.local)

PHASE 2: Software Installation
  [OS-Specific Path Chosen via get_os_name()]

  macOS: Xcode ’ Homebrew ’ packages ’ apps
  Ubuntu: apt update/upgrade ’ packages ’ Docker ’ cleanup
  Raspberry Pi OS: Similar to Ubuntu with ARM tools

  Shared Installations (all OSes):
      NVM and Node.js 22
      Vim with minpac plugins
      npm update

PHASE 3: System Preferences
  [OS-Specific Path Chosen via get_os_name()]

  macOS: Close System Prefs ’ Configure 15+ applications
  Ubuntu Server: Minimal configuration (privacy, terminal, UI)
  Ubuntu Workstation: GNOME settings + application preferences
  Raspberry Pi OS: Similar to Ubuntu with RPi adjustments

PHASE 4: Git Repository Initialization (Workstation/macOS Only)
  Check if workstation or macOS environment
  Verify Git is installed
  Check Git remote origin
  Initialize repository if needed
  Optionally update content from remote (interactive only)

PHASE 5: System Restart (Interactive Only)
  Prompt to restart system
```

---

## Key Observations

### OS Detection Strategy

The legacy system uses a two-level OS detection:

1. **Base OS Detection (`get_os()`):**
   - Returns: "macos", "ubuntu", or "raspbian"
   - Used for broad OS family decisions

2. **Detailed OS Detection (`get_os_name()`):**
   - Returns specific identifier with version and edition
   - Examples: "macos", "ubuntu-24-svr", "ubuntu-24-wks", "raspberry-pi-os"
   - Used to select correct installation/preference scripts

### Edition Detection Logic

For Ubuntu systems, edition is determined by:

- **WSL:** Presence of `/mnt/c` directory
- **Server:** No `$XDG_CURRENT_DESKTOP` environment variable
- **Workstation:** `$XDG_CURRENT_DESKTOP` is set (indicates GUI)

### Shared vs OS-Specific Scripts

**Shared Scripts (in `_legacy/src/os/installs/`):**
- `nvm.sh` - NVM and Node.js installation
- `npm.sh` - npm update
- `vim.sh` - Vim with plugins (calls OS-specific Vim install first)

**OS-Specific Scripts:**
- Package managers (Homebrew for macOS, apt for Ubuntu/Raspberry Pi OS)
- OS-specific packages and applications
- System preferences configuration

### Interactive vs Non-Interactive Modes

**Interactive Mode (default):**
- Prompts for installation directory
- Prompts for overwriting existing files
- Prompts for updating content from Git
- Prompts for system restart

**Non-Interactive Mode (`-y` flag):**
- Uses default directory `$HOME/projects/dotfiles`
- Overwrites existing files without prompting
- Skips Git update prompt
- Skips restart prompt

**Use Case:** Non-interactive mode designed for CI/CD pipelines and automated deployments

### Idempotency

The legacy system is idempotent in several ways:

- **Backups:** Only creates `-original` files if they don't exist
- **Symlinks:** Checks if symlink already correct before recreating
- **Local configs:** Only creates `.local` files if they don't exist or are empty
- **NVM:** Updates if exists, installs if doesn't
- **Vim plugins:** Removes and reinstalls to ensure clean state

### Error Handling

- Most operations use `execute()` function which:
  - Shows spinner while running
  - Captures stderr to temp file
  - Prints success or error with description
  - Shows error output if command fails
- Critical failures (OS verification, utils loading) exit immediately
- Non-critical failures print error but continue

---

## Files Referenced

### Core Setup Scripts
- `_legacy/src/os/setup.sh` - Main entry point
- `_legacy/src/os/utils.sh` - Core utility functions
- `_legacy/src/os/create_symbolic_links.sh` - Backup and symlink creation
- `_legacy/src/os/create_local_config_files.sh` - Local config file creation
- `_legacy/src/os/initialize_git_repository.sh` - Git repository initialization
- `_legacy/src/os/update_content.sh` - Git content update
- `_legacy/src/os/restart.sh` - System restart

### Installation Scripts (Orchestrators)
- `_legacy/src/os/installs/main.sh` - Installation phase entry point
- `_legacy/src/os/installs/macos/main.sh` - macOS installation orchestrator
- `_legacy/src/os/installs/ubuntu-24-svr/main.sh` - Ubuntu 24 Server orchestrator
- `_legacy/src/os/installs/ubuntu-24-wks/main.sh` - Ubuntu 24 Workstation orchestrator
- `_legacy/src/os/installs/raspberry-pi-os/main.sh` - Raspberry Pi OS orchestrator
- Other Ubuntu version orchestrators (20, 22, 23)

### Shared Installation Scripts
- `_legacy/src/os/installs/nvm.sh` - NVM and Node.js
- `_legacy/src/os/installs/npm.sh` - npm update
- `_legacy/src/os/installs/vim.sh` - Vim with plugins

### Preference Scripts (Orchestrators)
- `_legacy/src/os/preferences/main.sh` - Preferences phase entry point
- `_legacy/src/os/preferences/macos/main.sh` - macOS preferences orchestrator
- `_legacy/src/os/preferences/ubuntu-24-svr/main.sh` - Ubuntu 24 Server preferences
- `_legacy/src/os/preferences/ubuntu-24-wks/main.sh` - Ubuntu 24 Workstation preferences
- `_legacy/src/os/preferences/raspberry-pi-os/main.sh` - Raspberry Pi OS preferences
- Other Ubuntu version preferences (20, 22, 23)

### Utility Scripts
- `_legacy/src/os/installs/macos/utils.sh` - Homebrew utilities
- `_legacy/src/os/installs/ubuntu-24-svr/utils.sh` - APT utilities (same across Ubuntu versions)
- `_legacy/src/os/installs/raspberry-pi-os/utils.sh` - APT utilities for Raspberry Pi OS

---

## Differences from New System

The new system (`src/`) should follow a similar phased approach but with these improvements:

1. **Explicit Phase Identification:** Document and structure code by phase
2. **Oh My Bash Integration:** Replace custom prompt/completion with Oh My Bash
3. **Hierarchical Structure:** Use common ’ OS family ’ version ’ edition hierarchy
4. **Better Code Reuse:** Shared utilities at appropriate hierarchy levels
5. **Standard Package Managers:** Homebrew and apt only (no custom installers)
6. **Cleaner Organization:** Four top-level categories (files, installs, preferences, utils)
7. **Main Function Pattern:** All main.sh files use self-contained main() function
8. **No Bash Installation:** Use OS-provided Bash (legacy installs Bash via Homebrew on macOS)
9. **Modern Defaults:** Target current OS versions only (macOS Sonoma+, Ubuntu 24.04)
