# New Dotfiles Setup Process

This document describes the step-by-step process that the **new** dotfiles system (`src/`) follows when executing the setup. This mirrors the legacy process but incorporates the new hierarchical architecture, Oh My Bash integration, and modern best practices.

## Key Differences from Legacy System

**Architectural Changes:**
- Hierarchical organization: common → OS family → version → edition
- Oh My Bash replaces custom prompt, autocompletion, and color definitions
- Consolidated utility functions in `src/utils/` with clear hierarchy
- Single `main.sh` orchestrator per directory level
- All variables inside `main()` functions (no global scope pollution)

**What We're NOT Doing:**
- ❌ Custom prompt configuration (Oh My Bash themes handle this)
- ❌ Custom bash autocompletion scripts (Oh My Bash completions handle this)
- ❌ Custom color definitions (Oh My Bash handles this)
- ❌ Installing Bash via Homebrew on macOS (use OS-provided Bash)
- ❌ Installing full Xcode.app (only Xcode Command Line Tools)
- ❌ Duplicating base aliases across OS-specific files

**What We're Doing Differently:**
- ✅ Installing Oh My Bash framework early in Phase 2
- ✅ Hierarchical file resolution (common files executed first, then OS-specific)
- ✅ Simplified alias structure (universal + OS-specific only)
- ✅ Functions organized by category in custom Oh My Bash directory
- ✅ Standard package managers only (Homebrew, apt)

## Entry Point

**File:** `src/setup.sh`

**Execution Modes:**
- Interactive mode: `bash src/setup.sh` (asks for user confirmation)
- Non-interactive mode: `bash src/setup.sh -y` or `bash src/setup.sh --yes` (auto-confirms)

**Global Configuration:**
- Repository: `fredlackey/dotfiles-ohmybash`
- Default installation directory: `$HOME/projects/dotfiles`
- Git origin: `git@github.com:fredlackey/dotfiles-ohmybash.git`

**Remote Execution:**

**macOS:**
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/fredlackey/dotfiles-ohmybash/main/src/setup.sh)"
```

**Ubuntu/Raspberry Pi OS:**
```bash
bash -c "$(wget -qO - https://raw.githubusercontent.com/fredlackey/dotfiles-ohmybash/main/src/setup.sh)"
```

---

## PHASE 0: Bootstrap and Prerequisites

This phase handles the initial setup before any installations begin. It downloads the repository, verifies the OS, and prepares the environment.

### Step 0.1: Change to Script Directory

**File:** `src/setup.sh` (similar to legacy line 239)

**Action:**
- Changes to the directory containing setup.sh
- Ensures all relative paths work correctly

**Implementation:**
```bash
cd "$(dirname "${BASH_SOURCE[0]}")"
```

---

### Step 0.2: Load or Download Utilities

**File:** `src/setup.sh` (similar to legacy lines 246-250)

**Action:**
- Checks if `utils/common/utils.sh` exists locally
- If exists: Sources it directly
- If not exists: Downloads utils.sh from GitHub raw URL and sources it

**New File Paths:**
- `src/utils/common/utils.sh` - Core utilities
- `src/utils/common/logging.sh` - Logging functions
- `src/utils/common/prompt.sh` - User interaction
- `src/utils/common/execution.sh` - Command execution

**Purpose:** Make utility functions available for setup process

**Legacy vs. New:**
- **Legacy:** Single `utils.sh` file
- **New:** Organized into 4 separate files by function category

---

### Step 0.3: Verify Operating System

**File:** `src/setup.sh` (similar to legacy lines 257-258)

**Action:**
- Calls `verify_os()` function from `src/utils/common/utils.sh`
- Detects OS via `get_os()`: returns "macos", "ubuntu", or "raspbian"
- Gets OS version via `get_os_version()`
- Compares against minimum requirements:
  - macOS: 10.10 (Yosemite) - **Targeting 14+ (Sonoma) for new system**
  - Ubuntu: 20.04 LTS - **Targeting 24.04 LTS for new system**
  - Raspberry Pi OS: 10 (Buster) - **Targeting 12 (Bookworm) for new system**
- Exits if OS unsupported or version too old

**New Behavior:**
- More strict version requirements (targets modern OS only)
- Legacy versions supported only in `_legacy/` folder

---

### Step 0.4: Parse Arguments

**File:** `src/setup.sh` (similar to legacy lines 262-263)

**Action:**
- Checks for `-y` or `--yes` flags via `skip_questions()`
- Sets `skipQuestions=true` if found
- Controls whether to prompt user for confirmations

**Same as Legacy:** No changes

---

### Step 0.5: Request Sudo Access

**File:** `src/setup.sh` (similar to legacy line 267)

**Action:**
- Calls `ask_for_sudo()` function from `src/utils/common/prompt.sh`
- Prompts for sudo password upfront
- Starts background process to keep sudo alive every 60 seconds
- Prevents repeated password prompts during installation

**Same as Legacy:** No changes to behavior

---

### Step 0.6: Download Dotfiles (If Remote Execution)

**File:** `src/setup.sh` (similar to legacy lines 275-276)

**Condition:** Only runs if script was NOT executed locally

**Action via `download_dotfiles()` function:**

1. **Download Archive:**
   - Creates temporary file: `mktemp /tmp/XXXXX`
   - Downloads tarball from GitHub: `https://github.com/fredlackey/dotfiles-ohmybash/tarball/main`
   - Uses `download()` function from `src/utils/common/utils.sh`

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
   - Calls `extract()` function from `src/utils/common/utils.sh`
   - Executes: `tar --extract --gzip --file <archive> --strip-components 1 --directory <outputDir>`
   - `--strip-components 1` removes top-level GitHub directory wrapper

5. **Cleanup:**
   - Removes temporary tarball file
   - Changes directory to `$dotfilesDirectory/src`

**Same as Legacy:** Behavior identical, just different file paths internally

---

### Step 0.9: Install NVM and Node.js (Critical Dependency)

**File:** `src/setup.sh` (NEW - Phase 0.9)

**NEW IN REBUILD:** Node.js is now installed as a Phase 0 critical dependency

**Purpose:** Install Node Version Manager (NVM) and Node.js LTS before any other installations. This is a blocking phase - if it fails, the entire setup aborts.

**Action:**

1. **Create .bash.local:**
   - Creates `~/.bash.local` if it doesn't exist
   - This file will store NVM configuration

2. **Install NVM:**
   - Checks if `~/.nvm` directory exists
   - If not exists:
     - Clones NVM repository: `git clone https://github.com/nvm-sh/nvm.git ~/.nvm`
     - Aborts on failure with error message
   - If exists: Reports success (already installed)

3. **Configure NVM in .bash.local:**
   - Checks if NVM_DIR is already in `~/.bash.local`
   - If not configured:
     - Adds NVM configuration block:
       ```bash
       # NVM configuration
       export NVM_DIR="$HOME/.nvm"
       [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
       [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
       ```
     - Aborts on failure

4. **Source NVM:**
   - Exports `NVM_DIR` environment variable
   - Sources `nvm.sh` to make NVM available in current shell

5. **Install Node.js LTS:**
   - Executes: `. ~/.bash.local && nvm install --lts`
   - Installs the latest Long Term Support version via NVM
   - Aborts on failure with error message

6. **Set Node.js LTS as Default:**
   - Executes: `. ~/.bash.local && nvm alias default lts/*`
   - Sets LTS as the default Node.js version
   - Aborts on failure

7. **Update npm:**
   - Executes: `. ~/.bash.local && nvm use default && npm install --global --silent npm@latest`
   - Uses the default Node.js version (LTS)
   - Updates npm to latest version
   - Aborts on failure

8. **CRITICAL VALIDATION:**
   - **Validates NVM:** Checks if `nvm` command is accessible
     - Uses both `command -v nvm` and `type nvm` for reliability
     - Aborts if not accessible
   - **Validates Node:** Checks if `node` command is accessible
     - Gets and displays Node version
     - Aborts if not accessible
   - **Validates NPM:** Checks if `npm` command is accessible
     - Gets and displays npm version
     - Aborts if not accessible

**Why This is Critical:**
- Node.js/npm may be required by other installation scripts
- Package managers (Homebrew, apt) may have Node.js dependencies
- Better to fail early than discover missing Node.js mid-installation
- Validates the entire installation succeeded before continuing

**Differences from Legacy:**
- **Legacy:** NVM/Node version 22 installed in Phase 2 (Software Installation)
- **New:** NVM/Node LTS installed in Phase 0.9 (Bootstrap Prerequisites)
- **Legacy:** No validation checks - failures could go unnoticed
- **New:** Critical validation with immediate abort on failure
- **New:** Uses LTS version instead of hardcoded version for better stability

---

## PHASE 1: File System Setup

This phase backs up existing files and creates the dotfiles structure in the user's home directory.

### Step 1.1: Backup Original Bash Files

**File:** `src/setup.sh` calls function from `src/utils/common/utils.sh`

**Legacy Location:** `_legacy/src/os/create_symbolic_links.sh`
**New Location:** Function in `src/utils/common/utils.sh`

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
- `~/.bashrc` → `~/.bashrc-original`
- `~/.bash_profile` → `~/.bash_profile-original`

**Same as Legacy:** Behavior identical

---

### Step 1.2: Create Symbolic Links

**File:** `src/setup.sh` orchestrates, sources utilities from `src/utils/common/utils.sh`

**Legacy Approach:**
- Single `create_symbolic_links.sh` script
- Sources from one directory level (e.g., `shell/macos/`, `shell/ubuntu-24-svr/`)

**New Approach:**
- **Hierarchical resolution** - executes symlinks from multiple levels
- **Resolution order:** common → OS family → version → edition
- Files at more specific levels override general ones

**Execution Flow:**

1. **Determine OS Hierarchy Levels:**
   - Calls `get_os_name()` to get detailed OS identifier
   - Examples: "macos", "ubuntu-24-svr", "ubuntu-24-wks", "raspberry-pi-os"
   - Builds hierarchy path array:
     - For `ubuntu-24-svr`: ["common", "ubuntu", "ubuntu-24", "ubuntu-24-svr"]
     - For `macos`: ["common", "macos"]

2. **Execute Symlinks at Each Level:**
   - For each level in hierarchy:
     - Check if `src/files/{level}/` exists
     - If exists: Create symlinks from that level
     - More specific levels can override previous symlinks

3. **Files to Symlink (by category):**

   **From `src/files/common/`:**
   - `.gitconfig` (template)
   - `.gitignore` (global)
   - `.gitattributes`
   - `.editorconfig`
   - `.vimrc` (if not OS-specific)
   - `.tmux.conf` (if not OS-specific)

   **From `src/files/{os}/` (e.g., macos, ubuntu):**
   - OS-specific dotfiles
   - Application configuration files

   **From `src/files/{os-version-edition}/` (most specific):**
   - Edition-specific overrides

   **NOT Symlinked (Oh My Bash handles these):**
   - ❌ `.bashrc` - Oh My Bash creates this
   - ❌ `.bash_profile` - Oh My Bash creates this
   - ❌ `bash_prompt` - Replaced by Oh My Bash themes
   - ❌ `bash_autocompletion` - Replaced by Oh My Bash completions
   - ❌ `bash_colors` - Replaced by Oh My Bash themes

4. **Symlink Creation Logic:**
   - For each file at current hierarchy level:
     - **Source path:** `$dotfilesDirectory/src/files/{level}/{file}`
     - **Target path:** `$HOME/.{file}` (adds leading dot if not present)
     - If target doesn't exist OR skip questions mode: Creates symlink immediately
     - If target exists and is already correct symlink: Reports success (no action)
     - If target exists and is different:
       - Interactive mode: Prompts "do you want to overwrite it?"
       - User says yes: Removes target and creates symlink
       - User says no: Skips (reports warning)
     - Creates link: `ln -fs $sourceFile $targetFile`

**Example Symlinks:**
- `~/projects/dotfiles/src/files/common/.gitconfig` → `~/.gitconfig`
- `~/projects/dotfiles/src/files/ubuntu/.profile` → `~/.profile`
- `~/projects/dotfiles/src/files/macos/.bash_profile` → `~/.bash_profile` (if no Oh My Bash)

**Key Differences from Legacy:**
- **Hierarchical execution** instead of single directory
- **Skips Bash shell files** that Oh My Bash manages
- **More organized** by file category and specificity

---

### Step 1.3: Create Local Configuration Files

**File:** `src/setup.sh` calls functions from `src/utils/common/utils.sh`

**Legacy Location:** `_legacy/src/os/create_local_config_files.sh`
**New Location:** Functions in `src/utils/common/utils.sh`

**Purpose:** Create user-specific config files that are NOT tracked in Git

#### Create ~/.bash.local

**Action via `create_bash_local()` function:**

1. Checks if `~/.bash.local` exists or is empty
2. If doesn't exist or empty:
   - Determines dotfiles bin directory path (if exists)
   - Creates file with template:
     - Shebang: `#!/bin/bash`
     - Comment header
     - PATH addition: `PATH="/path/to/dotfiles/bin/:$PATH"` (if bin exists)
     - Export PATH
     - **NEW:** Placeholder for Oh My Bash custom configurations

**New Template Content:**
```bash
#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# User-specific Bash configurations (not tracked in Git)

# Set PATH additions
PATH="/path/to/dotfiles/bin/:$PATH"
export PATH

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Oh My Bash custom configurations can be added below
# This file is sourced by Oh My Bash automatically

```

**Purpose:** User-specific Bash configurations and PATH additions

**Differences from Legacy:**
- Added comment about Oh My Bash sourcing
- Clarified purpose for Oh My Bash integration

---

#### Create ~/.gitconfig.local

**Action via `create_gitconfig_local()` function:**

1. Checks if `~/.gitconfig.local` exists or is empty
2. If doesn't exist or empty:
   - Creates file with template:
     - `[commit]` section with commented-out `gpgsign = true`
     - `[user]` section with empty name and email fields
     - Commented-out `signingkey` field

**Template Content:**
```gitconfig
[commit]

    # Sign commits using GPG.
    # https://help.github.com/articles/signing-commits-using-gpg/

    # gpgsign = true


[user]

    name =
    email =
    # signingkey =
```

**Purpose:** User-specific Git settings (credentials, GPG keys)

**Same as Legacy:** No changes

---

#### Create ~/.vimrc.local

**Action via `create_vimrc_local()` function:**

1. Checks if `~/.vimrc.local` exists
2. If doesn't exist:
   - Creates empty file: `printf "" >> "$FILE_PATH"`

**Purpose:** User-specific Vim customizations

**Same as Legacy:** No changes

---

## PHASE 2: Software Installation

This phase installs all required software, packages, and tools. The installation process is OS-specific and follows hierarchical execution.

### Overview of Hierarchical Installation

**Legacy Approach:**
- Single OS-specific installation script (e.g., `_legacy/src/os/installs/ubuntu-24-svr/main.sh`)
- All installation logic in one place

**New Approach:**
- **Hierarchical execution** from general to specific
- Each level adds or refines installations
- Shared installations at appropriate hierarchy level

**Execution Order Example (Ubuntu 24 Server):**
```bash
src/installs/common/main.sh           # Universal installations
src/installs/ubuntu/main.sh           # Ubuntu family installations
src/installs/ubuntu-24/main.sh        # Ubuntu 24 specific installations
src/installs/ubuntu-24-svr/main.sh    # Ubuntu 24 Server specific installations
```

---

### Step 2.0: Execute Installation Hierarchy

**File:** `src/setup.sh` (orchestrates hierarchy)

**Action:**
1. Calls `get_os_name()` to determine detailed OS identifier
2. Builds hierarchy path array based on OS:
   - `macos` → ["common", "macos"]
   - `ubuntu-24-svr` → ["common", "ubuntu", "ubuntu-24", "ubuntu-24-svr"]
   - `raspberry-pi-os` → ["common", "pios"]
3. For each level in hierarchy:
   - Check if `src/installs/{level}/main.sh` exists
   - If exists: Execute `bash src/installs/{level}/main.sh`
   - Sources utilities appropriate for that level

**Key Difference from Legacy:**
- Multiple installation scripts execute in sequence
- Common installations happen first, then OS-specific

---

### Step 2.1: Common Installations (All Operating Systems)

**File:** `src/installs/common/main.sh`

**Purpose:** Install software that is universal across all OSes

**IMPORTANT:** NVM and Node.js are now installed in Phase 0.9 (before this phase) as critical dependencies.

**Execution Order:**

1. **Source Utilities:**
   ```bash
   source "${script_dir}/../utils/common/utils.sh"
   source "${script_dir}/../utils/common/logging.sh"
   source "${script_dir}/../utils/common/execution.sh"
   ```

2. **Install Oh My Bash:**
   - **Action:**
     - Check if `~/.oh-my-bash` already exists
     - If not exists:
       - Download Oh My Bash installation script
       - Run unattended installation: `--unattended` flag
       - Backup original `.bashrc` (Oh My Bash does this automatically)
     - If exists: Report success (already installed)
   - **Configuration:**
     - Set `OSH_THEME` to preferred theme (e.g., "font")
     - Enable base plugins: `plugins=(git)`
     - Configure in `~/.bashrc` after installation

   **NEW in New System:** Oh My Bash installation happens here

**Key Differences from Legacy:**
- **Oh My Bash installation added** as major step
- **NVM/Node/npm installation REMOVED** - now in Phase 0.9
- All common installations in one place
- Legacy had these scattered across OS-specific files

---

### Step 2.2: macOS Installation Process

**Hierarchy Execution:**
1. `src/installs/common/main.sh` (already executed)
2. `src/installs/macos/main.sh` (executes now)

**File:** `src/installs/macos/main.sh`

**Execution Order:**

1. **Source Utilities:**
   ```bash
   source "${script_dir}/../utils/common/utils.sh"
   source "${script_dir}/../utils/common/logging.sh"
   source "${script_dir}/../utils/macos/utils.sh"
   ```

2. **Install Xcode Command Line Tools:**
   - **File:** `src/installs/macos/xcode.sh`
   - **Action:**
     - Check if Xcode Command Line Tools installed: `xcode-select --print-path`
     - If not installed:
       - Execute: `xcode-select --install`
       - Wait for user to complete installation dialog
       - Verify installation completed
     - If installed: Report success (already installed)

   **Differences from Legacy:**
   - ❌ **Does NOT install Xcode.app** (full IDE not needed)
   - Legacy installed full Xcode from Mac App Store (10+ GB)
   - New system only installs Command Line Tools (essential dev utilities)

3. **Install Homebrew:**
   - **File:** `src/installs/macos/homebrew.sh`
   - **Action:**
     - Check if Homebrew installed: `command -v brew`
     - If not installed:
       - Execute: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
       - Wait for completion
       - Add to PATH if needed (Apple Silicon: `/opt/homebrew/bin`)
     - If installed: Skip installation
     - Configure Homebrew:
       - `brew analytics off` (opt-out of analytics)
       - `brew update` (update package index)
       - `brew upgrade` (upgrade existing packages)

   **Same as Legacy:** Behavior identical

4. **Install wget:**
   - **File:** `src/installs/macos/wget.sh`
   - **Action:**
     - Use `brew_install()` from `src/utils/macos/utils.sh`
     - Execute: `brew install wget`
   - **Reason:** macOS includes curl but not wget; both are needed

   **Same as Legacy:** Behavior identical

5. **Install Git:**
   - **File:** `src/installs/macos/git.sh`
   - **Action:**
     - Check if Git installed (comes with Xcode CLI Tools)
     - If not installed: `brew install git`
     - Verify installation: `git --version`

   **Same as Legacy:** Behavior identical

6. **Install tmux:**
   - **File:** `src/installs/macos/tmux.sh`
   - **Action:**
     - Use `brew_install()` function
     - Execute: `brew install tmux`

   **Same as Legacy:** Behavior identical

7. **Install Browsers:**
   - **File:** `src/installs/macos/browsers.sh`
   - **Action:**
     - Install Google Chrome: `brew install --cask google-chrome`
     - Install Chrome Canary: `brew install --cask google-chrome-canary`
     - Install Safari Technology Preview: `brew install --cask safari-technology-preview`

   **Same as Legacy:** Behavior identical

8. **Install Development Tools:**
   - **File:** `src/installs/macos/dev-tools.sh`
   - **Action:**
     - AWS CLI: `brew install awscli`
     - Terraform (tfenv): `brew install tfenv`
     - Tailscale: `brew install --cask tailscale`
     - jq: `brew install jq`
     - yq: `brew install yq`
     - lftp: `brew install lftp`
     - ffmpeg: `brew install ffmpeg`

   **Same as Legacy:** Similar packages, may be consolidated into one file

9. **Install Desktop Applications:**
   - **File:** `src/installs/macos/apps.sh`
   - **Action:** (using `brew install --cask`)
     - Adobe Creative Cloud
     - AppCleaner
     - Bambu Studio
     - Balena Etcher
     - Beyond Compare
     - Caffeine
     - ChatGPT
     - DbSchema
     - Docker
     - Elmedia Player
     - Microsoft Office 365
     - Microsoft Teams
     - Nord Pass
     - Slack
     - Snagit
     - Spotify
     - Sublime Text
     - Superwhisper
     - Termius
     - VLC
     - WhatsApp
     - Zoom

   **Same as Legacy:** Similar applications

10. **Install Visual Studio Code:**
    - **File:** `src/installs/macos/vscode.sh`
    - **Action:**
      - Install VS Code: `brew install --cask visual-studio-code`
      - Install Cursor: `brew install --cask cursor`
      - Install 30+ VS Code extensions via `code --install-extension`

    **Same as Legacy:** Behavior identical

11. **Install yt-dlp:**
    - **File:** `src/installs/macos/yt-dlp.sh`
    - **Action:**
      - Install: `brew install yt-dlp`

    **Same as Legacy:** Behavior identical

**Packages NOT Installed (Different from Legacy):**
- ❌ **Bash** - Use OS-provided Bash (legacy installed via Homebrew)
- ❌ **Bash Completion 2** - Oh My Bash handles completions
- ❌ **Xcode.app** - Full IDE not needed (only CLI tools)
- ❌ **GPG/Pinentry** - Not needed unless user specifically needs GPG signing
- ❌ **npm/Yarn** - npm comes with Node.js via NVM
- ❌ **ShellCheck** - Not needed for end-user dotfiles
- ❌ **Pasteboard** - Not commonly used
- ❌ Various niche tools from legacy system

---

### Step 2.3: Ubuntu Installation Process

**Hierarchy Execution:**
1. `src/installs/common/main.sh` (already executed)
2. `src/installs/ubuntu/main.sh` (executes now)
3. `src/installs/ubuntu-24/main.sh` (if Ubuntu 24)
4. `src/installs/ubuntu-24-svr/main.sh` (if Ubuntu 24 Server)
5. `src/installs/ubuntu-24-wks/main.sh` (if Ubuntu 24 Workstation)

---

#### Step 2.3a: Ubuntu Family Installations

**File:** `src/installs/ubuntu/main.sh`

**Purpose:** Install packages common to ALL Ubuntu versions (20, 22, 23, 24) and editions (svr, wks)

**Execution Order:**

1. **Source Utilities:**
   ```bash
   source "${script_dir}/../utils/common/utils.sh"
   source "${script_dir}/../utils/common/logging.sh"
   source "${script_dir}/../utils/ubuntu/utils.sh"
   ```

2. **Update Package Index:**
   - Call `update()` from `src/utils/ubuntu/utils.sh`
   - Executes: `sudo apt-get update -qqy`

3. **Upgrade Existing Packages:**
   - Call `upgrade()` from `src/utils/ubuntu/utils.sh`
   - Executes: `sudo apt-get upgrade -y`

4. **Install Build Essentials:**
   - **File:** `src/installs/ubuntu/build-essential.sh`
   - **Action:**
     - Use `install_package()` from `src/utils/ubuntu/utils.sh`
     - Install: `build-essential`, `debian-archive-keyring`

5. **Install Core Tools:**
   - **File:** `src/installs/ubuntu/core-tools.sh`
   - **Action:**
     - Install: `curl`, `wget`, `ca-certificates`, `software-properties-common`, `gnupg`

6. **Install Git:**
   - **File:** `src/installs/ubuntu/git.sh`
   - **Action:**
     - Install: `git`

7. **Install tmux:**
   - **File:** `src/installs/ubuntu/tmux.sh`
   - **Action:**
     - Install: `tmux`

8. **Install Tree:**
   - **File:** `src/installs/ubuntu/tree.sh`
   - **Action:**
     - Install: `tree`

9. **Install Tailscale:**
   - **File:** `src/installs/ubuntu/tailscale.sh`
   - **Action:**
     - Add Tailscale GPG key
     - Add Tailscale repository
     - Install: `tailscale`

**Key Differences from Legacy:**
- All Ubuntu common packages in one place
- Legacy had these repeated across ubuntu-20-svr, ubuntu-22-svr, etc.

---

#### Step 2.3b: Ubuntu 24 Specific Installations

**File:** `src/installs/ubuntu-24/main.sh`

**Purpose:** Install packages specific to Ubuntu 24.04 LTS (both server and workstation)

**Execution Order:**

1. **Source Utilities:**
   ```bash
   source "${script_dir}/../utils/common/utils.sh"
   source "${script_dir}/../utils/ubuntu/utils.sh"
   ```

2. **Install Docker:**
   - **File:** `src/installs/ubuntu-24/docker.sh`
   - **Action:**
     - Add Docker GPG key
     - Add Docker repository for Ubuntu 24.04
     - Install: `docker-ce`, `docker-ce-cli`, `containerd.io`
     - Install plugins: `docker-buildx-plugin`, `docker-compose-plugin`
     - Add user to docker group: `sudo usermod -aG docker $USER`

   **Same as Legacy:** Docker installation maintained

**Note:** Currently only Docker is version-specific; most packages work across Ubuntu versions

---

#### Step 2.3c: Ubuntu 24 Server Installations

**File:** `src/installs/ubuntu-24-svr/main.sh`

**Purpose:** Install packages specific to Ubuntu 24 **Server** edition (headless, no GUI)

**Execution Order:**

1. **Source Utilities:**
   ```bash
   source "${script_dir}/../utils/common/utils.sh"
   source "${script_dir}/../utils/ubuntu/utils.sh"
   ```

2. **Cleanup:**
   - Call `autoremove()` from `src/utils/ubuntu/utils.sh`
   - Executes: `sudo apt-get autoremove -y`
   - Call `apt clean`: Cleans package cache

**Server-Specific Notes:**
- No GUI applications installed
- Minimal package set
- Focus on CLI tools and services

**Same as Legacy:** Server edition remains minimal

---

#### Step 2.3d: Ubuntu 24 Workstation Installations

**File:** `src/installs/ubuntu-24-wks/main.sh`

**Purpose:** Install packages specific to Ubuntu 24 **Workstation** edition (desktop with GUI)

**Execution Order:**

1. **Source Utilities:**
   ```bash
   source "${script_dir}/../utils/common/utils.sh"
   source "${script_dir}/../utils/ubuntu/utils.sh"
   ```

2. **Install Chromium Browser:**
   - **File:** `src/installs/ubuntu-24-wks/chromium.sh`
   - **Action:**
     - Install: `chromium-browser`

3. **Cleanup:**
   - Call `autoremove()` and `apt clean`

**Workstation-Specific Notes:**
- Includes GUI applications
- Desktop environment integration

**Same as Legacy:** Workstation adds GUI apps to server base

---

### Step 2.4: Raspberry Pi OS Installation Process

**Hierarchy Execution:**
1. `src/installs/common/main.sh` (already executed)
2. `src/installs/pios/main.sh` (executes now)

**File:** `src/installs/pios/main.sh`

**Purpose:** Install packages for Raspberry Pi OS (Debian-based, ARM architecture)

**Execution Order:**

1. **Source Utilities:**
   ```bash
   source "${script_dir}/../utils/common/utils.sh"
   source "${script_dir}/../utils/common/logging.sh"
   source "${script_dir}/../utils/ubuntu/utils.sh"  # Raspberry Pi OS uses apt
   ```

2. **Update and Upgrade:**
   - Call `update()` and `upgrade()`

3. **Install Build Tools:**
   - **File:** `src/installs/pios/build-tools.sh`
   - **Action:**
     - Install: `build-essential`, `debian-archive-keyring`
     - Install: `python3-dev`, `python3-pip`
     - Install: `make`, `cmake`, `gcc`, `g++`

4. **Install Core Tools:**
   - Install: `curl`, `wget`, `ca-certificates`, `gnupg`

5. **Install System Tools:**
   - **File:** `src/installs/pios/system-tools.sh`
   - **Action:**
     - Install: `tree`, `htop`, `neofetch`, `vim`, `nano`
     - Install: `jq`

6. **Install Monitoring Tools:**
   - **File:** `src/installs/pios/monitoring.sh`
   - **Action:**
     - Install: `iotop`, `iftop`, `nethogs`, `nload`

7. **Install Raspberry Pi Specific:**
   - **File:** `src/installs/pios/raspberry-pi.sh`
   - **Action:**
     - Install: `raspi-config`

8. **Install Network Tools:**
   - Install: `net-tools`

9. **Install Database Tools:**
   - Install: `postgresql-client`

10. **Install Docker:**
    - Add Docker GPG key (ARM-compatible)
    - Add Docker repository for Raspberry Pi OS
    - Install: `docker-ce`, `docker-ce-cli`, `containerd.io`
    - Install plugins: `docker-buildx-plugin`, `docker-compose-plugin`

11. **Install tmux:**
    - Install: `tmux`

12. **Cleanup:**
    - Call `autoremove()` and `apt clean`

**Key Differences from Legacy:**
- ARM-specific considerations documented
- Docker installation adapted for ARM architecture
- Same as legacy but more organized

---

### Common Installation Notes

**Idempotency:**
- All installation scripts check if software already installed
- Skip installation if present
- Safe to run multiple times

**Error Handling:**
- Use `execute()` function for all installations
- Provides spinner, success/error feedback
- Captures errors for debugging

**Package Manager Functions:**
- macOS: Use functions from `src/utils/macos/utils.sh` (`brew_install`, etc.)
- Ubuntu/Raspberry Pi: Use functions from `src/utils/ubuntu/utils.sh` (`install_package`, etc.)

---

## PHASE 3: System Preferences Configuration

This phase configures OS-specific system preferences and settings using hierarchical execution.

### Overview of Hierarchical Preferences

**Legacy Approach:**
- Single OS-specific preferences script (e.g., `_legacy/src/os/preferences/ubuntu-24-svr/main.sh`)

**New Approach:**
- **Hierarchical execution** from general to specific
- Each level adds or refines preferences
- Shared preferences at appropriate hierarchy level

**Execution Order Example (Ubuntu 24 Server):**
```bash
src/preferences/common/main.sh           # Universal preferences
src/preferences/ubuntu/main.sh           # Ubuntu family preferences
src/preferences/ubuntu-24/main.sh        # Ubuntu 24 specific preferences
src/preferences/ubuntu-24-svr/main.sh    # Ubuntu 24 Server specific preferences
```

---

### Step 3.0: Execute Preferences Hierarchy

**File:** `src/setup.sh` (orchestrates hierarchy)

**Action:**
1. Calls `get_os_name()` to determine detailed OS identifier
2. Builds hierarchy path array based on OS
3. For each level in hierarchy:
   - Check if `src/preferences/{level}/main.sh` exists
   - If exists: Execute `bash src/preferences/{level}/main.sh`

---

### Step 3.1: Common Preferences (All Operating Systems)

**File:** `src/preferences/common/main.sh`

**Purpose:** Configure settings universal across all OSes

**Execution Order:**

1. **Source Utilities:**
   ```bash
   source "${script_dir}/../utils/common/utils.sh"
   source "${script_dir}/../utils/common/logging.sh"
   ```

2. **Configure Git:**
   - **File:** `src/preferences/common/git-config.sh`
   - **Action:**
     - Set global Git configuration from `~/.gitconfig` (symlinked from `src/files/common/.gitconfig`)
     - Verify `~/.gitconfig.local` exists (created in Phase 1)
     - Git automatically includes `.gitconfig.local` via `[include]` directive

**Note:** Common preferences are minimal - most preferences are OS-specific

---

### Step 3.2: macOS Preferences Configuration

**Hierarchy Execution:**
1. `src/preferences/common/main.sh` (already executed)
2. `src/preferences/macos/main.sh` (executes now)

**File:** `src/preferences/macos/main.sh`

**Purpose:** Configure macOS system preferences using `defaults write` commands

**Execution Order:**

1. **Source Utilities:**
   ```bash
   source "${script_dir}/../utils/common/utils.sh"
   source "${script_dir}/../utils/common/logging.sh"
   ```

2. **Close System Preferences:**
   - **File:** `src/preferences/macos/close-system-prefs.sh`
   - **Action:**
     - Execute AppleScript: `osascript -e 'tell application "System Preferences" to quit'`
     - Purpose: Prevents conflicts with preferences being changed

3. **Configure Applications and Settings (in order):**

   - **Mac App Store:** `src/preferences/macos/app-store.sh`
   - **Google Chrome:** `src/preferences/macos/chrome.sh`
   - **Dock:** `src/preferences/macos/dock.sh`
   - **Finder:** `src/preferences/macos/finder.sh`
   - **Firefox:** `src/preferences/macos/firefox.sh`
   - **Keyboard:** `src/preferences/macos/keyboard.sh`
   - **Language and Region:** `src/preferences/macos/language-region.sh`
   - **Maps:** `src/preferences/macos/maps.sh`
   - **Photos:** `src/preferences/macos/photos.sh`
   - **Safari:** `src/preferences/macos/safari.sh`
   - **Security and Privacy:** `src/preferences/macos/security-privacy.sh`
   - **Terminal:** `src/preferences/macos/terminal.sh`
   - **TextEdit:** `src/preferences/macos/textedit.sh`
   - **Trackpad:** `src/preferences/macos/trackpad.sh`
   - **UI and UX:** `src/preferences/macos/ui-ux.sh`

**Method:** Uses `defaults write` commands to modify plist files

**Same as Legacy:** macOS preferences identical to legacy approach

---

### Step 3.3: Ubuntu Preferences Configuration

**Hierarchy Execution:**
1. `src/preferences/common/main.sh` (already executed)
2. `src/preferences/ubuntu/main.sh` (executes now)
3. `src/preferences/ubuntu-24/main.sh` (if Ubuntu 24)
4. `src/preferences/ubuntu-24-svr/main.sh` (if Ubuntu 24 Server)
5. `src/preferences/ubuntu-24-wks/main.sh` (if Ubuntu 24 Workstation)

---

#### Step 3.3a: Ubuntu Family Preferences

**File:** `src/preferences/ubuntu/main.sh`

**Purpose:** Configure settings common to ALL Ubuntu versions and editions

**Execution Order:**

1. **Source Utilities:**
   ```bash
   source "${script_dir}/../utils/common/utils.sh"
   ```

2. **Configure Terminal:**
   - **File:** `src/preferences/ubuntu/terminal.sh`
   - **Action:**
     - Set terminal color scheme (if GNOME Terminal)
     - Configure terminal preferences

**Note:** Most Ubuntu preferences are edition-specific (server vs workstation)

---

#### Step 3.3b: Ubuntu 24 Server Preferences

**File:** `src/preferences/ubuntu-24-svr/main.sh`

**Purpose:** Configure Ubuntu 24 **Server** edition preferences

**Execution Order:**

1. **Source Utilities:**
   ```bash
   source "${script_dir}/../utils/common/utils.sh"
   ```

2. **Configure Privacy:**
   - **File:** `src/preferences/ubuntu-24-svr/privacy.sh`
   - **Action:**
     - Disable usage statistics reporting
     - Disable error reporting

3. **Configure UI/UX:**
   - **File:** `src/preferences/ubuntu-24-svr/ui-ux.sh`
   - **Action:**
     - Minimal UI settings for server environment
     - No desktop-specific settings

**Server Notes:**
- Minimal configuration (no GUI)
- Focus on privacy and security

---

#### Step 3.3c: Ubuntu 24 Workstation Preferences

**File:** `src/preferences/ubuntu-24-wks/main.sh`

**Purpose:** Configure Ubuntu 24 **Workstation** edition preferences

**Execution Order:**

1. **Source Utilities:**
   ```bash
   source "${script_dir}/../utils/common/utils.sh"
   ```

2. **Configure Privacy:**
   - **File:** `src/preferences/ubuntu-24-wks/privacy.sh`
   - **Action:**
     - Disable usage statistics
     - Configure privacy settings

3. **Configure GNOME Shell:**
   - **File:** `src/preferences/ubuntu-24-wks/gnome-shell.sh`
   - **Action:** (using `gsettings`)
     - Configure GNOME extensions
     - Set desktop behavior
     - Configure window management

4. **Configure Appearance:**
   - **File:** `src/preferences/ubuntu-24-wks/appearance.sh`
   - **Action:**
     - Set theme (dark/light)
     - Configure icon theme
     - Set font preferences

5. **Configure Keyboard:**
   - **File:** `src/preferences/ubuntu-24-wks/keyboard.sh`
   - **Action:**
     - Set keyboard shortcuts
     - Configure input sources

6. **Configure Terminal:**
   - **File:** `src/preferences/ubuntu-24-wks/terminal.sh`
   - **Action:**
     - Override Ubuntu family terminal settings
     - Add workstation-specific terminal preferences

**Workstation Notes:**
- Extensive GNOME desktop configuration
- GUI application preferences
- Uses `gsettings` and `dconf` commands

**Same as Legacy:** Workstation preferences similar to legacy

---

### Step 3.4: Raspberry Pi OS Preferences Configuration

**Hierarchy Execution:**
1. `src/preferences/common/main.sh` (already executed)
2. `src/preferences/pios/main.sh` (executes now)

**File:** `src/preferences/pios/main.sh`

**Purpose:** Configure Raspberry Pi OS preferences

**Execution Order:**

1. **Source Utilities:**
   ```bash
   source "${script_dir}/../utils/common/utils.sh"
   ```

2. **Configure Privacy:**
   - Similar to Ubuntu server

3. **Configure Terminal:**
   - Terminal color scheme
   - Terminal preferences

4. **Configure Raspberry Pi Specific:**
   - **File:** `src/preferences/pios/raspberry-pi.sh`
   - **Action:**
     - Configure via `raspi-config` commands (non-interactive)
     - Set locale, timezone, keyboard layout
     - Configure boot behavior
     - Enable/disable interfaces (SSH, VNC, SPI, I2C, etc.)

**Raspberry Pi Notes:**
- Similar to Ubuntu preferences
- Additional Raspberry Pi-specific hardware configurations
- ARM-optimized settings

**Same as Legacy:** Similar approach with ARM considerations

---

## PHASE 4: Oh My Bash Configuration

**NEW PHASE** - Not in legacy system

This phase configures Oh My Bash with custom themes, plugins, aliases, and functions.

### Step 4.1: Configure Oh My Bash Theme

**File:** `src/setup.sh` or helper script

**Action:**
1. Edit `~/.bashrc` (created by Oh My Bash in Phase 2)
2. Set `OSH_THEME` variable:
   ```bash
   OSH_THEME="font"  # or "agnoster", "powerline-light", etc.
   ```
3. Options:
   - Use default theme ("font")
   - Select specific theme
   - Enable random theme selection

**Replaces Legacy:**
- ❌ Custom `bash_prompt` files
- ✅ Oh My Bash themes provide prompt customization

---

### Step 4.2: Enable Oh My Bash Plugins

**File:** `src/setup.sh` or helper script

**Action:**
1. Edit `~/.bashrc`
2. Set `plugins` array:
   ```bash
   plugins=(
     git
     docker
     node
     nvm
   )
   ```
3. Add OS-specific plugins conditionally:
   ```bash
   # macOS-specific
   if [[ "$OSTYPE" == "darwin"* ]]; then
       plugins+=(osx brew)
   fi
   ```

**Replaces Legacy:**
- ❌ Custom Git helper functions
- ❌ Custom tool-specific aliases
- ✅ Oh My Bash plugins provide these

---

### Step 4.3: Copy Custom Functions to Oh My Bash Custom Directory

**File:** `src/setup.sh` calls copy function

**Action:**
1. Create `$OSH_CUSTOM` directory structure:
   ```bash
   mkdir -p "$OSH_CUSTOM/functions"
   mkdir -p "$OSH_CUSTOM/aliases"
   ```

2. **Copy Custom Functions:**
   - Source: `src/files/common/bash_functions` (if exists)
   - Target: `$OSH_CUSTOM/functions/custom.sh`
   - Contains all custom functions from legacy `bash_functions`:
     - `dp()` - Docker ps formatting
     - `clone()` - Git clone with dependency install
     - `datauri()` - Create data URI
     - `delete-files()` - Delete by pattern
     - `h()` - History search
     - `s()` - Project search
     - `clean-dev()` - Remove node_modules
     - `docker-clean()` - Remove Docker resources
     - `git-push()` - Add, commit, push
     - `backup-*()` - Backup functions
     - `get-*()` - yt-dlp wrappers
     - `nginx-init()`, `certbot-init()` - Server setup
     - And all other custom functions

3. **Copy Custom Aliases:**
   - Source: `src/files/common/bash_aliases` (custom aliases only)
   - Target: `$OSH_CUSTOM/aliases/custom.aliases.sh`
   - Contains only truly custom aliases (not overlapping with Oh My Bash)

4. **Copy Bash Options:**
   - Source: `src/files/common/bash_options`
   - Target: `$OSH_CUSTOM/bash_options.sh`
   - Contains: `shopt` settings, `set -o vi`, etc.

**Replaces Legacy:**
- Legacy had `bash_functions` sourced directly
- New system uses Oh My Bash custom directory
- Oh My Bash automatically loads files from `$OSH_CUSTOM/`

---

### Step 4.4: Configure OS-Specific Oh My Bash Customizations

**File:** `src/setup.sh` or helper script

**Action:**
1. **Create OS-specific custom files:**

   **macOS:**
   - Copy: `src/files/macos/bash_aliases` → `$OSH_CUSTOM/macos.aliases.sh`
   - Contains: Homebrew aliases, macOS-specific shortcuts

   **Ubuntu:**
   - Copy: `src/files/ubuntu/bash_aliases` → `$OSH_CUSTOM/ubuntu.aliases.sh`
   - Contains: APT aliases, Linux-specific shortcuts

   **Raspberry Pi OS:**
   - Copy: `src/files/pios/bash_aliases` → `$OSH_CUSTOM/raspberry-pi.aliases.sh`
   - Contains: Raspberry Pi-specific aliases (`pi-temp`, `pi-throttle`, etc.)

2. **Add conditional loading to `~/.bashrc`:**
   ```bash
   # Load OS-specific customizations
   if [[ "$OSTYPE" == "darwin"* ]]; then
       [ -f "$OSH_CUSTOM/macos.aliases.sh" ] && source "$OSH_CUSTOM/macos.aliases.sh"
   elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
       if [ -f /etc/lsb-release ]; then
           [ -f "$OSH_CUSTOM/ubuntu.aliases.sh" ] && source "$OSH_CUSTOM/ubuntu.aliases.sh"
       fi
       if [ -f /proc/device-tree/model ] && grep -q "Raspberry Pi" /proc/device-tree/model 2>/dev/null; then
           [ -f "$OSH_CUSTOM/raspberry-pi.aliases.sh" ] && source "$OSH_CUSTOM/raspberry-pi.aliases.sh"
       fi
   fi
   ```

**Replaces Legacy:**
- Legacy had separate OS-specific shell directories
- New system uses single Oh My Bash installation with conditional loading

---

### Step 4.5: Verify Oh My Bash Configuration

**File:** `src/setup.sh` or verification script

**Action:**
1. Source `~/.bashrc` in current shell
2. Verify theme loaded: Check `$OSH_THEME`
3. Verify plugins loaded: Check `$plugins` array
4. Test custom functions: Call `dp`, `h`, etc.
5. Test custom aliases: Run macOS/Ubuntu-specific aliases
6. Verify prompt displays correctly

---

## PHASE 5: Git Repository Initialization (Workstation/macOS Only)

This phase initializes the dotfiles directory as a Git repository and optionally updates content.

**Same as Legacy:** Behavior identical

### Step 5.1: Check Environment Type

**File:** `src/setup.sh` (similar to legacy lines 297-298)

**Condition:**
- Only runs for workstation and macOS environments
- Checks: `if [[ "$os_name" == *"-wks" ]] || [[ "$os_name" == "macos" ]]`
- Server editions (`-svr`) skip this phase

**Rationale:** Keep servers lean without Git repository overhead

---

### Step 5.2: Verify Git is Installed

**File:** `src/setup.sh`

**Action:**
- Calls `cmd_exists "git"` from `src/utils/common/utils.sh`
- Only proceeds if Git command is available

---

### Step 5.3: Check Git Remote

**File:** `src/setup.sh`

**Action:**
- Gets current Git remote origin: `git config --get remote.origin.url`
- Compares to expected: `git@github.com:fredlackey/dotfiles-ohmybash.git`
- If different or not set: Initialize Git repository

---

### Step 5.4: Initialize Git Repository

**File:** `src/setup.sh` calls function from `src/utils/common/utils.sh`

**Legacy Location:** `_legacy/src/os/initialize_git_repository.sh`
**New Location:** Function `initialize_git_repository()` in `src/utils/common/utils.sh`

**Action:**

1. **Validate Origin URL:**
   - Checks that origin URL parameter was provided
   - Exits with error if missing

2. **Check if Already Git Repository:**
   - Calls `is_git_repository()` function
   - If NOT a repository: Proceed with initialization

3. **Initialize and Set Remote:**
   - Changes to dotfiles root directory
   - Executes: `git init && git remote add origin <git_origin>`
   - Sets up repository for tracking changes

**Same as Legacy:** Behavior identical

---

### Step 5.5: Update Content (Interactive Only)

**File:** `src/setup.sh` (similar to legacy lines 308-310)

**Condition:** Only runs in interactive mode (not with `-y` flag)

**Action:**

1. **Verify GitHub SSH Access:**
   - Tests: `ssh -T git@github.com`
   - If fails: Prompts user to set up SSH key
   - Provides instructions or script to configure SSH

2. **Prompt to Update:**
   - Asks: "Do you want to update the content from the 'dotfiles' directory?"
   - If user confirms yes:
     - Fetches all remotes: `git fetch --all`
     - Hard resets to origin/main: `git reset --hard origin/main`
     - Checks out main branch: `git checkout main`
     - Cleans untracked files: `git clean -fd`

**Purpose:** Synchronize local dotfiles with remote repository

**Same as Legacy:** Behavior identical

---

## PHASE 6: System Restart (Interactive Only)

Final phase that optionally restarts the system to apply all changes.

**Same as Legacy:** Behavior identical

### Step 6.1: Prompt for Restart

**File:** `src/setup.sh` (similar to legacy lines 318-320)

**Condition:** Only runs in interactive mode (not with `-y` flag)

**Action:**

1. **Display Prompt:**
   - Prints: "Do you want to restart?"
   - Waits for user confirmation

2. **Restart System:**
   - If user answers yes:
     - Executes: `sudo shutdown -r now`
     - System restarts immediately

**Rationale:** Some system preferences and installations require restart to take full effect

**Same as Legacy:** Behavior identical

---

## Process Flow Summary

```
PHASE 0: Bootstrap and Prerequisites
├─ Load or download utilities (NEW: 4 separate utility files)
├─ Verify OS and version (NEW: Stricter version requirements)
├─ Parse arguments (-y flag)
├─ Request sudo access
├─ Download dotfiles (if remote execution)
├─ Install critical OS prerequisites (Xcode CLI Tools / build-essential)
└─ Install NVM and Node.js (NEW: CRITICAL - aborts on failure)
   ├─ Install NVM
   ├─ Configure NVM in .bash.local
   ├─ Install Node.js LTS
   ├─ Set Node.js LTS as default
   ├─ Update npm to latest
   └─ Validate NVM, Node, and npm are accessible (CRITICAL)

PHASE 1: File System Setup
├─ Backup existing .bash* files
├─ Create symbolic links (NEW: Hierarchical execution, skips Oh My Bash files)
└─ Create local configuration files (.bash.local, .gitconfig.local, .vimrc.local)

PHASE 2: Software Installation
├─ [Hierarchical Execution from common → OS → version → edition]
│
├─ COMMON (all OSes):
│  └─ Install Oh My Bash (NEW)
│     (Note: NVM/Node.js now installed in Phase 0.9)
│
├─ macOS:
│  ├─ Install Xcode CLI Tools (NOT full Xcode.app) (CHANGED)
│  ├─ Install Homebrew
│  ├─ Install wget
│  ├─ Install Git
│  ├─ Install tmux
│  ├─ Install Browsers
│  ├─ Install Development Tools
│  ├─ Install Desktop Applications
│  ├─ Install VS Code + Cursor
│  └─ Install yt-dlp
│
├─ Ubuntu Family:
│  ├─ apt update/upgrade
│  ├─ Install build-essential
│  ├─ Install core tools (curl, wget, etc.)
│  ├─ Install Git
│  ├─ Install tmux
│  ├─ Install tree
│  └─ Install Tailscale
│
├─ Ubuntu 24:
│  └─ Install Docker
│
├─ Ubuntu 24 Server:
│  └─ Cleanup (autoremove)
│
├─ Ubuntu 24 Workstation:
│  ├─ Install Chromium
│  └─ Cleanup
│
└─ Raspberry Pi OS:
   ├─ Install build tools (extended)
   ├─ Install system tools
   ├─ Install monitoring tools
   ├─ Install Raspberry Pi specific tools
   ├─ Install Docker (ARM)
   └─ Cleanup

PHASE 3: System Preferences
├─ [Hierarchical Execution from common → OS → version → edition]
│
├─ COMMON: Configure Git
│
├─ macOS:
│  ├─ Close System Preferences
│  └─ Configure 15+ applications (defaults write)
│
├─ Ubuntu Family: Configure Terminal
│
├─ Ubuntu 24 Server:
│  ├─ Configure Privacy
│  └─ Configure UI/UX (minimal)
│
├─ Ubuntu 24 Workstation:
│  ├─ Configure Privacy
│  ├─ Configure GNOME Shell
│  ├─ Configure Appearance
│  ├─ Configure Keyboard
│  └─ Configure Terminal
│
└─ Raspberry Pi OS:
   ├─ Configure Privacy
   ├─ Configure Terminal
   └─ Configure Raspberry Pi specific

PHASE 4: Oh My Bash Configuration (NEW PHASE)
├─ Configure Oh My Bash theme
├─ Enable Oh My Bash plugins (git, docker, node, etc.)
├─ Copy custom functions to $OSH_CUSTOM/functions/
├─ Copy custom aliases to $OSH_CUSTOM/aliases/
├─ Copy bash options to $OSH_CUSTOM/
├─ Configure OS-specific customizations
└─ Verify Oh My Bash configuration

PHASE 5: Git Repository Initialization (Workstation/macOS Only)
├─ Check if workstation or macOS environment
├─ Verify Git is installed
├─ Check Git remote origin
├─ Initialize repository if needed
└─ Optionally update content from remote (interactive only)

PHASE 6: System Restart (Interactive Only)
└─ Prompt to restart system
```

---

## Key Architectural Differences Summary

### Node.js as Phase 0 Critical Dependency

**Legacy:**
- NVM and Node.js version 22 installed in Phase 2 (Software Installation)
- Installed as part of common installations
- No validation checks after installation
- Failures could go unnoticed until later
- Hardcoded to specific version

**New:**
- **NVM and Node.js LTS installed in Phase 0.9 (Bootstrap Prerequisites)**
- **Installed BEFORE file operations and Oh My Bash**
- **Uses LTS version** instead of hardcoded version for better stability
- **Critical validation checks:** NVM, Node, and npm must be accessible
- **Immediate abort on failure** - setup cannot continue without Node.js
- Better fail-fast approach prevents wasted time on incomplete setup

**Why This Matters:**
- Node.js may be required by other installation scripts
- Package managers may have Node.js dependencies
- Configuration tools may need npm packages
- Early installation ensures availability for all subsequent phases
- LTS version provides better long-term stability and security

---

### Hierarchical Execution

**Legacy:**
- Single script per OS (e.g., `ubuntu-24-svr/main.sh`)
- All logic in one place
- Duplication across similar OS versions

**New:**
- Multiple scripts execute in hierarchy
- Shared logic at appropriate level
- No duplication across similar OS versions
- Example: `common/main.sh` → `ubuntu/main.sh` → `ubuntu-24/main.sh` → `ubuntu-24-svr/main.sh`

---

### Oh My Bash Integration

**Legacy:**
- Custom prompt in `bash_prompt` files
- Custom autocompletion in `bash_autocompletion` files
- Custom color definitions in `bash_colors` files
- Custom Git parsing functions

**New:**
- ✅ Oh My Bash themes replace custom prompts
- ✅ Oh My Bash completions replace custom autocompletion
- ✅ Oh My Bash handles colors automatically
- ✅ Oh My Bash Git plugin replaces custom Git functions
- ❌ No longer maintain custom prompt/completion code

---

### Utility Function Organization

**Legacy:**
- Single `utils.sh` file with all functions
- Located in `_legacy/src/os/utils.sh`

**New:**
- Organized into 4 files by category:
  - `src/utils/common/utils.sh` - Core utilities
  - `src/utils/common/logging.sh` - Logging functions
  - `src/utils/common/prompt.sh` - User interaction
  - `src/utils/common/execution.sh` - Command execution
- OS-specific utilities in `src/utils/{os}/utils.sh`

---

### Package Installation Differences

**What's NOT Installed:**
- ❌ Bash via Homebrew on macOS (use OS-provided)
- ❌ Bash Completion 2 (Oh My Bash handles this)
- ❌ Full Xcode.app (only CLI Tools)
- ❌ Various niche legacy tools

**What's NEW:**
- ✅ Oh My Bash framework
- ✅ Cursor (AI-powered editor)

**What Moved:**
- 🔄 NVM and Node.js moved from Phase 2 to Phase 0.9 (critical dependency)

---

### File Organization

**Legacy:**
- Files in `src/shell/`, `src/git/`, `src/vim/`, etc.
- OS-specific directories: `src/shell/macos/`, `src/shell/ubuntu-24-svr/`

**New:**
- Files in `src/files/` with hierarchy
- Structure: `src/files/common/`, `src/files/macos/`, `src/files/ubuntu-24-svr/`
- Oh My Bash custom files in `$OSH_CUSTOM/`

---

### Alias and Function Management

**Legacy:**
- Aliases in `bash_aliases` files (duplicated across OSes)
- Functions in `bash_functions` file
- Sourced directly from dotfiles

**New:**
- Universal aliases in `src/files/common/bash_aliases` (minimal)
- OS-specific aliases in `src/files/{os}/bash_aliases`
- All aliases copied to `$OSH_CUSTOM/aliases/`
- All functions copied to `$OSH_CUSTOM/functions/`
- Oh My Bash automatically loads from `$OSH_CUSTOM/`

---

## Testing and Verification

### Per-Phase Verification

**After Phase 1:**
- [ ] Verify backups created: `ls -la ~/*.bash*-original`
- [ ] Verify symlinks created: `ls -la ~/.gitconfig ~/.vimrc ~/.tmux.conf`
- [ ] Verify local files created: `ls -la ~/.bash.local ~/.gitconfig.local ~/.vimrc.local`

**After Phase 2:**
- [ ] Verify Oh My Bash installed: `ls -la ~/.oh-my-bash`
- [ ] Verify NVM installed: `command -v nvm`
- [ ] Verify Node.js LTS installed: `node --version` (should show LTS version)
- [ ] Verify Vim installed: `vim --version`
- [ ] macOS: Verify Homebrew installed: `brew --version`
- [ ] Ubuntu: Verify Docker installed: `docker --version`

**After Phase 3:**
- [ ] Verify Git configured: `git config --get user.name`
- [ ] macOS: Verify Dock preferences applied
- [ ] Ubuntu: Verify privacy settings applied

**After Phase 4:**
- [ ] Verify Oh My Bash theme loaded: `echo $OSH_THEME`
- [ ] Verify plugins loaded: `echo ${plugins[@]}`
- [ ] Verify custom functions work: `type dp h s`
- [ ] Verify custom aliases work: Test OS-specific aliases

**After Phase 5:**
- [ ] Verify Git repository initialized: `git status`
- [ ] Verify Git remote set: `git config --get remote.origin.url`

**After Phase 6:**
- [ ] System restarts (if user chose yes)

---

## Rollback and Recovery

### If Something Goes Wrong

**Restore Original Bash Files:**
```bash
# Restore original .bashrc
cp ~/.bashrc-original ~/.bashrc

# Restore original .bash_profile
cp ~/.bash_profile-original ~/.bash_profile
```

**Uninstall Oh My Bash:**
```bash
uninstall_oh_my_bash
```

**Restore Previous Configuration:**
- Oh My Bash automatically backs up as `~/.bashrc.omb-TIMESTAMP`
- Find backup: `ls -la ~/.bashrc.omb-*`
- Restore: `cp ~/.bashrc.omb-TIMESTAMP ~/.bashrc`

---

## Migration from Legacy System

If migrating from legacy dotfiles to new system:

1. **Backup existing dotfiles:**
   ```bash
   cp -r ~/projects/dotfiles ~/projects/dotfiles-backup
   ```

2. **Clone new repository:**
   ```bash
   git clone git@github.com:fredlackey/dotfiles-ohmybash.git ~/projects/dotfiles-new
   ```

3. **Run new setup:**
   ```bash
   cd ~/projects/dotfiles-new
   bash src/setup.sh
   ```

4. **Verify everything works:**
   - Open new terminal
   - Test custom functions
   - Test custom aliases
   - Verify Oh My Bash theme displays

5. **Remove legacy dotfiles (optional):**
   ```bash
   rm -rf ~/projects/dotfiles-backup  # Only after verifying new system works
   ```

---

## Related Documentation

- `ai-docs/LEGACY_SETUP_PROCESS.md` - Legacy setup process (for reference)
- `ai-docs/ABOUT_OHMYBASH.md` - Oh My Bash capabilities
- `ai-docs/BASH_FILE_OVERLAP.md` - Migration guide from legacy to Oh My Bash
- `ai-docs/UTILITY_FUNCTIONS.md` - Utility function reference
- `ai-docs/PREREQUISITES.md` - System prerequisites
- `docs/FILE_STRUCTURE.md` - Directory organization
- `docs/INSTALLS.md` - Package installation reference
- `CLAUDE.md` - Project overview and guidance
