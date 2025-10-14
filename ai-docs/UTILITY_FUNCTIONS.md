# Legacy Utility Functions

This document catalogs reusable utility functions from the `_legacy/` folder that are generic, OS-agnostic, and useful for the new dotfiles system. These functions handle common tasks like OS detection, user prompts, output formatting, command execution, and package management.

## Source Files

**Primary Utilities:**
- `_legacy/src/os/utils.sh` - Core utility functions (OS detection, printing, execution)
- `_legacy/src/os/installs/macos/utils.sh` - Homebrew-specific helpers
- `_legacy/src/os/installs/ubuntu-24-svr/utils.sh` - apt-specific helpers (same across all Ubuntu versions)
- `_legacy/src/os/installs/raspberry-pi-os/utils.sh` - apt-specific helpers for Raspberry Pi OS

## Phase 0: Setup and Bootstrap Functions

These functions handle the initial download, extraction, backup, and setup of the dotfiles before any installation begins. They are found in the legacy `setup.sh`, `create_symbolic_links.sh`, `create_local_config_files.sh`, and `initialize_git_repository.sh` scripts.

### Download and Extraction Functions

#### `download()`
**Location:** `_legacy/src/os/setup.sh:30`

**Purpose:** Download a file from a URL using curl or wget.

**Parameters:**
- `$1` - URL to download from
- `$2` - Output file path

**Returns:**
- `0` if download succeeds
- `1` if both curl and wget are unavailable or download fails

**Implementation:**
```bash
download() {
    local url="$1"
    local output="$2"

    if command -v "curl" &> /dev/null; then
        curl \
            --location \
            --silent \
            --show-error \
            --output "$output" \
            "$url" \
                &> /dev/null
        return $?
    elif command -v "wget" &> /dev/null; then
        wget \
            --quiet \
            --output-document="$output" \
            "$url" \
                &> /dev/null
        return $?
    fi

    return 1
}
```

**Usage:**
```bash
tmpFile="$(mktemp /tmp/XXXXX)"
download "https://github.com/user/repo/tarball/main" "$tmpFile"
```

---

#### `download_dotfiles()`
**Location:** `_legacy/src/os/setup.sh:62`

**Purpose:** Download dotfiles repository tarball, prompt for installation directory, extract archive.

**Behavior:**
1. Prints purple section header
2. Creates temporary file with `mktemp /tmp/XXXXX`
3. Downloads tarball from `$DOTFILES_TARBALL_URL`
4. Prompts user for installation directory (default: `$HOME/projects/dotfiles`)
5. Handles existing directory (prompt for overwrite or choose new location)
6. Creates directory with `mkdir -p`
7. Extracts archive to directory
8. Removes temporary file
9. Changes to `$dotfilesDirectory/src/os`

**Interactive Mode:**
- Prompts for directory confirmation
- Prompts if directory already exists

**Non-Interactive Mode (`-y` flag):**
- Uses default directory
- Overwrites existing directory without prompting

**Usage:**
```bash
# Called automatically by setup.sh if script wasn't run from local clone
printf "%s" "${BASH_SOURCE[0]}" | grep "setup.sh" &> /dev/null \
    || download_dotfiles
```

---

#### `download_utils()`
**Location:** `_legacy/src/os/setup.sh:136`

**Purpose:** Download utility functions file when setup is run remotely.

**Behavior:**
1. Creates temporary file
2. Downloads `utils.sh` from `$DOTFILES_UTILS_URL`
3. Sources the downloaded file
4. Removes temporary file

**Returns:**
- `0` if successful
- `1` if download or sourcing fails

**Usage:**
```bash
if [ -x "utils.sh" ]; then
    . "utils.sh" || exit 1
else
    download_utils || exit 1
fi
```

---

#### `extract()`
**Location:** `_legacy/src/os/setup.sh:151`

**Purpose:** Extract a gzipped tarball to a directory.

**Parameters:**
- `$1` - Archive file path
- `$2` - Output directory

**Returns:**
- `0` if extraction succeeds
- `1` if tar command unavailable or extraction fails

**Implementation:**
```bash
extract() {
    local archive="$1"
    local outputDir="$2"

    if command -v "tar" &> /dev/null; then
        tar \
            --extract \
            --gzip \
            --file "$archive" \
            --strip-components 1 \
            --directory "$outputDir"
        return $?
    fi

    return 1
}
```

**Usage:**
```bash
extract "$tmpFile" "$dotfilesDirectory"
```

**Note:** `--strip-components 1` removes the top-level directory from the GitHub tarball.

---

#### `verify_os()`
**Location:** `_legacy/src/os/setup.sh:172`

**Purpose:** Verify the operating system is supported and meets minimum version requirements.

**Minimum Versions:**
- macOS: 10.10 (Yosemite)
- Ubuntu: 20.04 LTS
- Raspberry Pi OS: 10 (Buster)

**Returns:**
- `0` if OS is supported and version meets minimum
- `1` if OS unsupported or version too old

**Behavior:**
- Calls `get_os()` to determine OS type
- Calls `get_os_version()` to get version string
- Calls `is_supported_version()` to compare versions
- Prints error message if unsupported

**Usage:**
```bash
verify_os || exit 1
```

---

### Backup and Symlink Functions

#### `backup_bash_files()`
**Location:** `_legacy/src/os/create_symbolic_links.sh:8`

**Purpose:** Backup existing Bash configuration files before creating symlinks.

**Behavior:**
1. Finds all files matching `$HOME/.bash*` (max depth 1, files only)
2. Skips files already ending in `-original` (preserves existing backups)
3. Checks if backup file exists
4. If backup doesn't exist, creates copy with `-original` suffix
5. If backup exists, prints success message (no action)

**Files Backed Up:**
- `.bashrc`
- `.bash_profile`
- `.bash_aliases`
- `.bash_logout`
- `.bash_history`
- Any other `.bash*` files

**Implementation:**
```bash
backup_bash_files() {
    find "$HOME" -maxdepth 1 -name ".bash*" -type f | while IFS= read -r file; do
        # Skip files that are already backups (end with -original)
        if [[ "$file" == *-original* ]]; then
            continue
        fi

        # Only create backup if it doesn't already exist
        if [ -e "${file}-original" ]; then
            print_success "Backup of ${file} already exists (preserved)"
        else
            execute "cp $file ${file}-original" "Backup $file"
        fi
    done
}
```

**Idempotent:** Safe to run multiple times - preserves existing backups.

**Usage:**
```bash
backup_bash_files "$@"
```

---

#### `create_symlinks()`
**Location:** `_legacy/src/os/create_symbolic_links.sh:24`

**Purpose:** Create symbolic links from dotfiles repository to home directory.

**Parameters:**
- `$@` - Command-line arguments (checks for `-y`/`--yes` flag)

**Files Symlinked:**
- Shell: bash_aliases, bash_autocompletion, bash_exports, bash_functions, bash_init, bash_logout, bash_options, bash_profile, bash_prompt, bashrc, curlrc, inputrc
- Git: gitattributes, gitconfig, gitignore
- tmux: tmux.conf
- Vim: vim/ (directory), vimrc

**Behavior:**
1. Determines OS name via `get_os_name()`
2. Checks for OS-specific shell files (e.g., `shell/macos/`, `shell/ubuntu-24-svr/`)
3. For each file in list:
   - Builds source path: `$dotfilesDirectory/src/<category>/<file>`
   - Builds target path: `$HOME/.<file>` (adds leading dot)
   - If target doesn't exist OR skip questions: Creates symlink
   - If target exists and is correct symlink: Reports success
   - If target exists and is different: Prompts for overwrite (interactive mode)
4. Creates symlinks with `ln -fs`

**Interactive Mode:**
- Prompts before overwriting existing files
- User can choose to overwrite or skip

**Non-Interactive Mode (`-y` flag):**
- Overwrites all files without prompting

**Usage:**
```bash
create_symlinks "$@"
```

---

### Local Configuration Functions

#### `create_bash_local()`
**Location:** `_legacy/src/os/create_local_config_files.sh:8`

**Purpose:** Create `~/.bash.local` file for user-specific Bash configurations.

**Behavior:**
1. Checks if `~/.bash.local` exists or is empty
2. If doesn't exist or empty:
   - Determines dotfiles bin directory path
   - Creates file with template content:
     - Shebang: `#!/bin/bash`
     - PATH addition pointing to dotfiles bin directory
     - Export PATH
3. Prints result

**Template Content:**
```bash
#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set PATH additions.

PATH="/path/to/dotfiles/bin/:$PATH"

export PATH
```

**Usage:**
```bash
create_bash_local
```

**Note:** This file is NOT tracked in Git - it's for user-specific configurations.

---

#### `create_gitconfig_local()`
**Location:** `_legacy/src/os/create_local_config_files.sh:35`

**Purpose:** Create `~/.gitconfig.local` file for user-specific Git settings.

**Behavior:**
1. Checks if `~/.gitconfig.local` exists or is empty
2. If doesn't exist or empty:
   - Creates file with template content:
     - Commit section with commented-out GPG signing
     - User section with empty name, email, and commented signingkey
3. Prints result

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

**Usage:**
```bash
create_gitconfig_local
```

**Note:** This file is NOT tracked in Git - it contains sensitive information like credentials.

---

#### `create_vimrc_local()`
**Location:** `_legacy/src/os/create_local_config_files.sh:64`

**Purpose:** Create `~/.vimrc.local` file for user-specific Vim customizations.

**Behavior:**
1. Checks if `~/.vimrc.local` exists
2. If doesn't exist:
   - Creates empty file with `printf "" >> "$FILE_PATH"`
3. Prints result

**Usage:**
```bash
create_vimrc_local
```

**Note:** This file is NOT tracked in Git - users add their own Vim customizations.

---

### Git Repository Functions

#### `initialize_git_repository()`
**Location:** `_legacy/src/os/initialize_git_repository.sh:8`

**Purpose:** Initialize Git repository in dotfiles directory and set remote origin.

**Parameters:**
- `$1` - Git origin URL (e.g., `git@github.com:user/repo.git`)

**Behavior:**
1. Validates that origin URL was provided (exits with error if not)
2. Checks if current directory is already a Git repository via `is_git_repository()`
3. If NOT a Git repository:
   - Changes to dotfiles root directory (`cd ../../`)
   - Runs `git init`
   - Adds remote origin: `git remote add origin $GIT_ORIGIN`
4. Prints result

**Usage:**
```bash
if [ "$(git config --get remote.origin.url)" != "$DOTFILES_ORIGIN" ]; then
    ./initialize_git_repository.sh "$DOTFILES_ORIGIN"
fi
```

**When This Runs:**
- Only on macOS or workstation editions (`-wks`)
- NOT on server editions (`-svr`)
- Only if Git is installed
- Only if remote origin URL is not already set correctly

---

## Core Utility Functions

### OS Detection

#### `get_os()`
**Location:** `_legacy/src/os/utils.sh:118`

**Purpose:** Detect the base operating system.

**Returns:**
- `"macos"` - macOS/Darwin
- `"ubuntu"`, `"raspbian"`, etc. - Linux distributions (reads from `/etc/os-release`)
- Kernel name if unable to determine

**Usage:**
```bash
os="$(get_os)"
if [ "$os" == "macos" ]; then
    # macOS-specific code
fi
```

**Implementation:**
```bash
get_os() {
    local os=""
    local kernelName=""

    kernelName="$(uname -s)"

    if [ "$kernelName" == "Darwin" ]; then
        os="macos"
    elif [ "$kernelName" == "Linux" ] && \
         [ -e "/etc/os-release" ]; then
        os="$(. /etc/os-release; printf "%s" "$ID")"
    else
        os="$kernelName"
    fi

    printf "%s" "$os"
}
```

---

#### `get_os_name()`
**Location:** `_legacy/src/os/utils.sh:140`

**Purpose:** Get detailed OS identifier including version and edition (server/workstation/WSL).

**Returns:**
- `"macos"` - macOS
- `"raspberry-pi-os"` - Raspberry Pi OS (any version)
- `"ubuntu-24-svr"` - Ubuntu 24 Server
- `"ubuntu-24-wks"` - Ubuntu 24 Workstation
- `"ubuntu-24-wsl"` - Ubuntu 24 on Windows Subsystem for Linux

**Detection Logic:**
- WSL: Checks for `/mnt/c` directory
- Server: No `$XDG_CURRENT_DESKTOP` environment variable
- Workstation: Has `$XDG_CURRENT_DESKTOP` set

**Usage:**
```bash
os_name="$(get_os_name)"
case "$os_name" in
    ubuntu-24-svr)
        # Server-specific setup
        ;;
    ubuntu-24-wks)
        # Desktop-specific setup
        ;;
esac
```

---

#### `get_os_version()`
**Location:** `_legacy/src/os/utils.sh:181`

**Purpose:** Get the OS version string.

**Returns:**
- macOS: Product version from `sw_vers -productVersion` (e.g., "14.2.1")
- Linux: VERSION_ID from `/etc/os-release` (e.g., "24.04")

**Usage:**
```bash
version="$(get_os_version)"
echo "Running OS version: $version"
```

---

### User Interaction Functions

#### `ask()`
**Location:** `_legacy/src/os/utils.sh:9`

**Purpose:** Ask user a question and read response into `$REPLY`.

**Parameters:**
- `$1` - Question to display

**Usage:**
```bash
ask "What is your name?"
name="$(get_answer)"
```

---

#### `ask_for_confirmation()`
**Location:** `_legacy/src/os/utils.sh:14`

**Purpose:** Ask yes/no question and read single character response.

**Parameters:**
- `$1` - Question to display

**Returns:** Result stored in `$REPLY` variable

**Usage:**
```bash
ask_for_confirmation "Do you want to continue?"
if answer_is_yes; then
    # User said yes
fi
```

---

#### `answer_is_yes()`
**Location:** `_legacy/src/os/utils.sh:3`

**Purpose:** Check if user's answer (in `$REPLY`) is yes.

**Returns:**
- `0` (success) if `$REPLY` is Y or y
- `1` (failure) otherwise

**Usage:**
```bash
ask_for_confirmation "Install package?"
if answer_is_yes; then
    install_package
fi
```

---

#### `get_answer()`
**Location:** `_legacy/src/os/utils.sh:114`

**Purpose:** Retrieve the user's answer from `$REPLY`.

**Returns:** Contents of `$REPLY` variable

**Usage:**
```bash
ask "Enter directory name:"
dirname="$(get_answer)"
```

---

#### `ask_for_sudo()`
**Location:** `_legacy/src/os/utils.sh:20`

**Purpose:** Request sudo privileges and keep them alive for the duration of the script.

**Behavior:**
- Prompts for sudo password upfront
- Keeps sudo timestamp updated every 60 seconds in background
- Continues until parent script exits

**Usage:**
```bash
ask_for_sudo
# Rest of script can use sudo without prompting
```

---

#### `skip_questions()`
**Location:** `_legacy/src/os/utils.sh:313`

**Purpose:** Check if `-y` or `--yes` flag was passed to skip confirmation prompts.

**Returns:**
- `0` if `-y` or `--yes` found
- `1` otherwise

**Usage:**
```bash
if skip_questions "$@"; then
    # Auto-yes mode
else
    ask_for_confirmation "Continue?"
fi
```

---

### Output/Printing Functions

#### `print_in_color()`
**Location:** `_legacy/src/os/utils.sh:259`

**Purpose:** Print text in specified color using tput.

**Parameters:**
- `$1` - Text to print
- `$2` - Color code (1=red, 2=green, 3=yellow, 5=purple)

**Usage:**
```bash
print_in_color "Warning message" 3  # Yellow
```

---

#### `print_in_green()`
**Location:** `_legacy/src/os/utils.sh:266`

**Purpose:** Print text in green (success color).

**Usage:**
```bash
print_in_green "Operation successful\n"
```

---

#### `print_in_red()`
**Location:** `_legacy/src/os/utils.sh:274`

**Purpose:** Print text in red (error color).

**Usage:**
```bash
print_in_red "Operation failed\n"
```

---

#### `print_in_yellow()`
**Location:** `_legacy/src/os/utils.sh:278`

**Purpose:** Print text in yellow (warning/question color).

**Usage:**
```bash
print_in_yellow "Are you sure?\n"
```

---

#### `print_in_purple()`
**Location:** `_legacy/src/os/utils.sh:270`

**Purpose:** Print text in purple (section headers).

**Usage:**
```bash
print_in_purple "\n • Installing Packages\n\n"
```

---

#### `print_success()`
**Location:** `_legacy/src/os/utils.sh:298`

**Purpose:** Print success message with green checkmark.

**Parameters:**
- `$1` - Message to display

**Output:** `   [✔] message`

**Usage:**
```bash
print_success "Package installed"
```

---

#### `print_error()`
**Location:** `_legacy/src/os/utils.sh:249`

**Purpose:** Print error message with red X.

**Parameters:**
- `$1` - Primary error message
- `$2` - Optional secondary message

**Output:** `   [✖] message`

**Usage:**
```bash
print_error "Installation failed" "Package not found"
```

---

#### `print_warning()`
**Location:** `_legacy/src/os/utils.sh:302`

**Purpose:** Print warning message with yellow exclamation.

**Parameters:**
- `$1` - Warning message

**Output:** `   [!] message`

**Usage:**
```bash
print_warning "This operation cannot be undone"
```

---

#### `print_question()`
**Location:** `_legacy/src/os/utils.sh:282`

**Purpose:** Print question with yellow question mark (no newline).

**Parameters:**
- `$1` - Question text

**Output:** `   [?] question`

**Usage:**
```bash
print_question "Enter your choice: "
```

---

#### `print_result()`
**Location:** `_legacy/src/os/utils.sh:286`

**Purpose:** Print success or error based on exit code.

**Parameters:**
- `$1` - Exit code (0 = success, non-zero = error)
- `$2` - Message to display

**Returns:** The exit code passed in

**Usage:**
```bash
some_command
print_result $? "Command execution"
```

---

#### `print_error_stream()`
**Location:** `_legacy/src/os/utils.sh:253`

**Purpose:** Read from stdin and print each line as an error with arrow prefix.

**Output:** `   [✖] ↳ ERROR: line`

**Usage:**
```bash
command 2>&1 | print_error_stream
```

---

### Command Execution Functions

#### `execute()`
**Location:** `_legacy/src/os/utils.sh:54`

**Purpose:** Execute command with spinner, capture output, and print result.

**Parameters:**
- `$1` - Command(s) to execute
- `$2` - Human-readable description (optional, defaults to `$1`)

**Returns:** Exit code of executed command

**Behavior:**
- Executes command in background
- Shows animated spinner while running
- Captures stderr to temp file
- Prints success or error with description
- Shows error output if command fails

**Usage:**
```bash
execute "brew install wget" "wget"
execute "npm install" "Installing Node packages"
```

---

#### `cmd_exists()`
**Location:** `_legacy/src/os/utils.sh:39`

**Purpose:** Check if a command exists in PATH.

**Parameters:**
- `$1` - Command name

**Returns:**
- `0` if command exists
- `1` if command not found

**Usage:**
```bash
if cmd_exists "brew"; then
    echo "Homebrew is installed"
fi
```

---

#### `show_spinner()`
**Location:** `_legacy/src/os/utils.sh:327`

**Purpose:** Display animated spinner while process runs (used by `execute()`).

**Parameters:**
- `$1` - Process ID to monitor
- `$2` - Command being executed
- `$3` - Message to display

**Behavior:**
- Shows rotating spinner: `/-\|`
- Updates every 0.2 seconds
- Special handling for Travis CI environment

**Note:** Internal function, typically called by `execute()`.

---

### Process Management

#### `kill_all_subprocesses()`
**Location:** `_legacy/src/os/utils.sh:43`

**Purpose:** Kill all background jobs spawned by current script.

**Usage:**
```bash
set_trap "EXIT" "kill_all_subprocesses"
```

---

#### `set_trap()`
**Location:** `_legacy/src/os/utils.sh:306`

**Purpose:** Set a trap for signal/event if not already set.

**Parameters:**
- `$1` - Signal or event (e.g., "EXIT", "SIGINT")
- `$2` - Command to execute

**Usage:**
```bash
set_trap "EXIT" "cleanup_function"
```

---

### File System Functions

#### `mkd()`
**Location:** `_legacy/src/os/utils.sh:235`

**Purpose:** Create directory with error handling and user feedback.

**Parameters:**
- `$1` - Directory path to create

**Behavior:**
- Checks if path already exists as file (error)
- Checks if directory already exists (success, no action)
- Creates directory with `mkdir -p` if needed

**Usage:**
```bash
mkd "$HOME/.config/myapp"
```

---

### Version Comparison

#### `is_supported_version()`
**Location:** `_legacy/src/os/utils.sh:204`

**Purpose:** Compare two version strings (semantic versioning).

**Parameters:**
- `$1` - Current version
- `$2` - Required minimum version

**Returns:**
- `0` if current >= required
- `1` if current < required

**Usage:**
```bash
if is_supported_version "$(get_os_version)" "22.04"; then
    echo "OS version is supported"
fi
```

---

### Git Functions

#### `is_git_repository()`
**Location:** `_legacy/src/os/utils.sh:200`

**Purpose:** Check if current directory is inside a Git repository.

**Returns:**
- `0` if in Git repository
- `1` otherwise

**Usage:**
```bash
if is_git_repository; then
    git pull
fi
```

---

## Package Manager Functions

### Homebrew (macOS)

**Location:** `_legacy/src/os/installs/macos/utils.sh`

#### `brew_install()`
**Location:** `_legacy/src/os/installs/macos/utils.sh:8`

**Purpose:** Install Homebrew formula with error checking.

**Parameters:**
- `$1` - Human-readable name
- `$2` - Formula name
- `$3` - Additional arguments (optional)
- `$4` - Tap repository (optional)

**Behavior:**
- Checks if Homebrew is installed
- Executes `brew tap` if tap repository specified
- Checks if formula already installed
- Installs formula if not present

**Usage:**
```bash
brew_install "Wget" "wget"
brew_install "Docker" "docker" "--cask"
brew_install "MongoDB" "mongodb-community" "" "mongodb/brew"
```

---

#### `brew_update()`
**Location:** `_legacy/src/os/installs/macos/utils.sh:71`

**Purpose:** Update Homebrew package index.

**Usage:**
```bash
brew_update
```

---

#### `brew_upgrade()`
**Location:** `_legacy/src/os/installs/macos/utils.sh:79`

**Purpose:** Upgrade all installed Homebrew packages.

**Usage:**
```bash
brew_upgrade
```

---

#### `brew_prefix()`
**Location:** `_legacy/src/os/installs/macos/utils.sh:51`

**Purpose:** Get Homebrew installation prefix.

**Returns:** Homebrew prefix path (e.g., `/usr/local` or `/opt/homebrew`)

**Usage:**
```bash
prefix="$(brew_prefix)"
echo "Homebrew is at: $prefix"
```

---

#### `brew_tap()`
**Location:** `_legacy/src/os/installs/macos/utils.sh:67`

**Purpose:** Add Homebrew tap repository.

**Parameters:**
- `$1` - Tap repository (e.g., "homebrew/cask-fonts")

**Usage:**
```bash
brew_tap "homebrew/cask-fonts"
```

---

### APT (Ubuntu/Debian)

**Location:** `_legacy/src/os/installs/ubuntu-24-svr/utils.sh` (same across all Ubuntu/Raspberry Pi versions)

#### `install_package()`
**Location:** `_legacy/src/os/installs/ubuntu-24-svr/utils.sh:35`

**Purpose:** Install apt package with error checking.

**Parameters:**
- `$1` - Human-readable name
- `$2` - Package name
- `$3` - Extra apt arguments (optional)

**Behavior:**
- Checks if package already installed via `dpkg`
- Installs package if not present
- Uses `-y` for auto-yes, `-qq` for quiet output

**Usage:**
```bash
install_package "Build Essential" "build-essential"
install_package "Docker" "docker-ce"
```

---

#### `package_is_installed()`
**Location:** `_legacy/src/os/installs/ubuntu-24-svr/utils.sh:51`

**Purpose:** Check if apt package is installed.

**Parameters:**
- `$1` - Package name

**Returns:**
- `0` if installed
- `1` if not installed

**Usage:**
```bash
if package_is_installed "nginx"; then
    echo "Nginx is installed"
fi
```

---

#### `update()`
**Location:** `_legacy/src/os/installs/ubuntu-24-svr/utils.sh:55`

**Purpose:** Update apt package index.

**Usage:**
```bash
update
```

---

#### `upgrade()`
**Location:** `_legacy/src/os/installs/ubuntu-24-svr/utils.sh:65`

**Purpose:** Upgrade all installed apt packages.

**Behavior:**
- Uses non-interactive mode
- Auto-accepts new config files with `--force-confnew`

**Usage:**
```bash
upgrade
```

---

#### `autoremove()`
**Location:** `_legacy/src/os/installs/ubuntu-24-svr/utils.sh:24`

**Purpose:** Remove unused apt packages.

**Usage:**
```bash
autoremove
```

---

#### `add_ppa()`
**Location:** `_legacy/src/os/installs/ubuntu-24-svr/utils.sh:16`

**Purpose:** Add Ubuntu PPA repository.

**Parameters:**
- `$1` - PPA identifier (without "ppa:" prefix)

**Usage:**
```bash
add_ppa "git-core/ppa"
```

---

#### `add_key()`
**Location:** `_legacy/src/os/installs/ubuntu-24-svr/utils.sh:8`

**Purpose:** Download and add GPG key for package repository.

**Parameters:**
- `$1` - URL of GPG key

**Usage:**
```bash
add_key "https://download.docker.com/linux/ubuntu/gpg"
```

---

#### `add_to_source_list()`
**Location:** `_legacy/src/os/installs/ubuntu-24-svr/utils.sh:20`

**Purpose:** Add repository to apt sources list.

**Parameters:**
- `$1` - Repository deb line
- `$2` - Source list filename

**Usage:**
```bash
add_to_source_list "http://repo.example.com/ubuntu focal main" "example.list"
```

---

## Function Placement Map

This section identifies the precise location where each utility function should be placed in the new `src/utils/` hierarchy based on OS specificity.

### Phase 0 Functions Placement

**Bootstrap/Setup Functions:**
These functions handle initial download and preparation. They are currently in separate legacy scripts but should be consolidated:

| Function | Current Location | New Location | Notes |
|----------|------------------|--------------|-------|
| `download()` | `_legacy/src/os/setup.sh:30` | `src/utils/common/utils.sh` | Universal - works on all OSes |
| `download_dotfiles()` | `_legacy/src/os/setup.sh:62` | `src/setup.sh` | Orchestration - stays in main setup script |
| `download_utils()` | `_legacy/src/os/setup.sh:136` | `src/setup.sh` | Orchestration - stays in main setup script |
| `extract()` | `_legacy/src/os/setup.sh:151` | `src/utils/common/utils.sh` | Universal - works on all OSes |
| `verify_os()` | `_legacy/src/os/setup.sh:172` | `src/utils/common/utils.sh` | Uses get_os() and is_supported_version() |
| `backup_bash_files()` | `_legacy/src/os/create_symbolic_links.sh:8` | `src/utils/common/utils.sh` | Universal - works on all OSes |
| `create_symlinks()` | `_legacy/src/os/create_symbolic_links.sh:24` | `src/setup.sh` or dedicated script | Complex orchestration function |
| `create_bash_local()` | `_legacy/src/os/create_local_config_files.sh:8` | `src/utils/common/utils.sh` | Universal - creates local config |
| `create_gitconfig_local()` | `_legacy/src/os/create_local_config_files.sh:35` | `src/utils/common/utils.sh` | Universal - creates local config |
| `create_vimrc_local()` | `_legacy/src/os/create_local_config_files.sh:64` | `src/utils/common/utils.sh` | Universal - creates local config |
| `initialize_git_repository()` | `_legacy/src/os/initialize_git_repository.sh:8` | `src/utils/common/utils.sh` | Universal - Git operation |

**Rationale:**
- Simple utility functions (download, extract, backup, create local files) → `src/utils/common/utils.sh`
- Orchestration functions (download_dotfiles, download_utils, create_symlinks) → Stay in `src/setup.sh` or dedicated scripts
- All Phase 0 functions are OS-agnostic and belong at the common level

---

### `src/utils/common/utils.sh`
**Level:** Universal (all operating systems)

Functions that work identically across all OSes:

**Phase 0 Utilities (from table above):**
- `download()` - Download files using curl or wget
- `extract()` - Extract gzipped tarball
- `verify_os()` - Verify OS is supported and meets minimum version
- `backup_bash_files()` - Backup existing .bash* files
- `create_bash_local()` - Create ~/.bash.local template
- `create_gitconfig_local()` - Create ~/.gitconfig.local template
- `create_vimrc_local()` - Create ~/.vimrc.local empty file
- `initialize_git_repository()` - Initialize Git repo and set remote

**OS Detection:**
- `get_os()` - Detects base OS (macOS, ubuntu, raspbian, etc.)
- `get_os_name()` - Detailed OS identifier with version and edition
- `get_os_version()` - OS version string

**Command Utilities:**
- `cmd_exists()` - Check if command exists in PATH

**Process Management:**
- `kill_all_subprocesses()` - Kill all background jobs
- `set_trap()` - Set signal trap if not already set

**Version Comparison:**
- `is_supported_version()` - Semantic version comparison

**Git Utilities:**
- `is_git_repository()` - Check if in Git repository

**File System:**
- `mkd()` - Create directory with error handling

**Argument Parsing:**
- `skip_questions()` - Check for -y/--yes flag

---

### `src/utils/common/logging.sh`
**Level:** Universal (all operating systems)

All output/printing functions that use standard `tput`:

**Color Printing:**
- `print_in_color()` - Print text in specified color
- `print_in_green()` - Print in green (success)
- `print_in_red()` - Print in red (error)
- `print_in_yellow()` - Print in yellow (warning/question)
- `print_in_purple()` - Print in purple (section headers)

**Status Messages:**
- `print_success()` - Green checkmark with message
- `print_error()` - Red X with message
- `print_warning()` - Yellow exclamation with message
- `print_question()` - Yellow question mark with message
- `print_result()` - Success or error based on exit code
- `print_error_stream()` - Stream error lines with prefix

---

### `src/utils/common/prompt.sh`
**Level:** Universal (all operating systems)

User interaction and prompt functions:

**User Input:**
- `ask()` - Ask question and read response
- `ask_for_confirmation()` - Ask yes/no question
- `answer_is_yes()` - Check if answer is yes
- `get_answer()` - Get response from $REPLY

**Privilege Management:**
- `ask_for_sudo()` - Request and maintain sudo privileges

---

### `src/utils/common/execution.sh`
**Level:** Universal (all operating systems)

Command execution with feedback:

**Execution:**
- `execute()` - Execute command with spinner and feedback
- `show_spinner()` - Display animated spinner (internal to execute)

---

### `src/utils/macos/utils.sh`
**Level:** OS Family (all macOS versions)

Homebrew package manager functions:

**Homebrew Core:**
- `brew_install()` - Install Homebrew formula
- `brew_update()` - Update Homebrew package index
- `brew_upgrade()` - Upgrade all Homebrew packages
- `brew_prefix()` - Get Homebrew installation prefix
- `brew_tap()` - Add Homebrew tap repository

**Rationale:** All Homebrew functions are macOS-specific but version-independent. They work across all macOS versions (Sonoma, Sequoia, etc.).

---

### `src/utils/ubuntu/utils.sh`
**Level:** OS Family (all Ubuntu versions)

APT package manager functions shared across all Ubuntu and Debian-based systems:

**APT Core:**
- `install_package()` - Install apt package
- `package_is_installed()` - Check if package installed
- `update()` - Update apt package index
- `upgrade()` - Upgrade all apt packages
- `autoremove()` - Remove unused packages

**Repository Management:**
- `add_ppa()` - Add Ubuntu PPA repository
- `add_key()` - Add GPG key for repository
- `add_to_source_list()` - Add repository to sources.list

**Rationale:** These apt functions are identical across Ubuntu 20, 22, 23, 24, and all editions (svr, wks, wsl). The `_legacy/` code already demonstrates this - the utils.sh files in ubuntu-20-svr, ubuntu-22-svr, ubuntu-23-svr, and ubuntu-24-svr are identical.

**Note:** These functions also work for Raspberry Pi OS since it's Debian-based and uses apt.

---

### `src/utils/pios/utils.sh`
**Level:** OS Family (Raspberry Pi OS)

Currently no Raspberry Pi OS-specific utilities needed. The apt functions in `src/utils/ubuntu/utils.sh` handle Raspberry Pi OS package management since it uses the same apt system.

**Usage:** Raspberry Pi OS scripts should source both:
- `src/utils/common/utils.sh` - Core utilities
- `src/utils/ubuntu/utils.sh` - APT functions (work on Raspberry Pi OS)

**Future:** If Raspberry Pi OS-specific utilities are needed (ARM-specific tools, GPIO utilities, etc.), they would go here.

---

## Placement Summary Table

| Function | Location | Reason |
|----------|----------|--------|
| **OS Detection** | | |
| `get_os()` | `common/utils.sh` | Universal OS detection |
| `get_os_name()` | `common/utils.sh` | Universal OS identification |
| `get_os_version()` | `common/utils.sh` | Universal version detection |
| **Logging** | | |
| `print_in_color()` | `common/logging.sh` | Universal tput colors |
| `print_in_green()` | `common/logging.sh` | Universal tput colors |
| `print_in_red()` | `common/logging.sh` | Universal tput colors |
| `print_in_yellow()` | `common/logging.sh` | Universal tput colors |
| `print_in_purple()` | `common/logging.sh` | Universal tput colors |
| `print_success()` | `common/logging.sh` | Universal output format |
| `print_error()` | `common/logging.sh` | Universal output format |
| `print_warning()` | `common/logging.sh` | Universal output format |
| `print_question()` | `common/logging.sh` | Universal output format |
| `print_result()` | `common/logging.sh` | Universal output format |
| `print_error_stream()` | `common/logging.sh` | Universal output format |
| **User Prompts** | | |
| `ask()` | `common/prompt.sh` | Universal user input |
| `ask_for_confirmation()` | `common/prompt.sh` | Universal user input |
| `answer_is_yes()` | `common/prompt.sh` | Universal user input |
| `get_answer()` | `common/prompt.sh` | Universal user input |
| `ask_for_sudo()` | `common/prompt.sh` | Universal sudo management |
| `skip_questions()` | `common/utils.sh` | Universal argument parsing |
| **Execution** | | |
| `execute()` | `common/execution.sh` | Universal command execution |
| `show_spinner()` | `common/execution.sh` | Universal spinner display |
| **Utilities** | | |
| `cmd_exists()` | `common/utils.sh` | Universal command checking |
| `mkd()` | `common/utils.sh` | Universal directory creation |
| `is_supported_version()` | `common/utils.sh` | Universal version comparison |
| `is_git_repository()` | `common/utils.sh` | Universal Git detection |
| `kill_all_subprocesses()` | `common/utils.sh` | Universal process management |
| `set_trap()` | `common/utils.sh` | Universal trap management |
| **Homebrew (macOS)** | | |
| `brew_install()` | `macos/utils.sh` | macOS-specific (all versions) |
| `brew_update()` | `macos/utils.sh` | macOS-specific (all versions) |
| `brew_upgrade()` | `macos/utils.sh` | macOS-specific (all versions) |
| `brew_prefix()` | `macos/utils.sh` | macOS-specific (all versions) |
| `brew_tap()` | `macos/utils.sh` | macOS-specific (all versions) |
| **APT (Ubuntu/Debian)** | | |
| `install_package()` | `ubuntu/utils.sh` | Ubuntu family (all versions/editions) |
| `package_is_installed()` | `ubuntu/utils.sh` | Ubuntu family (all versions/editions) |
| `update()` | `ubuntu/utils.sh` | Ubuntu family (all versions/editions) |
| `upgrade()` | `ubuntu/utils.sh` | Ubuntu family (all versions/editions) |
| `autoremove()` | `ubuntu/utils.sh` | Ubuntu family (all versions/editions) |
| `add_ppa()` | `ubuntu/utils.sh` | Ubuntu family (all versions/editions) |
| `add_key()` | `ubuntu/utils.sh` | Ubuntu family (all versions/editions) |
| `add_to_source_list()` | `ubuntu/utils.sh` | Ubuntu family (all versions/editions) |

---

## Recommended Directory Structure

```
src/utils/
├── common/
│   ├── utils.sh           # OS detection, file system, git, version comparison,
│   │                      # command checking, process management, argument parsing
│   ├── logging.sh         # All print_* functions (color, status messages)
│   ├── prompt.sh          # User input and sudo management (ask*, answer_is_yes, get_answer)
│   └── execution.sh       # Command execution with spinner (execute, show_spinner)
├── macos/
│   └── utils.sh           # All brew_* functions (Homebrew package management)
├── ubuntu/
│   └── utils.sh           # All apt functions + repository management
│   │                      # (used by all Ubuntu versions AND Raspberry Pi OS)
└── pios/
    └── utils.sh           # Currently empty (Raspberry Pi OS uses ubuntu/utils.sh)
                           # Future: ARM-specific, GPIO, or RPi-specific utilities
```

---

## Implementation Notes

### Sourcing Pattern

Scripts should source utilities based on their needs:

**All scripts:**
```bash
source "${script_dir}/../utils/common/utils.sh"
source "${script_dir}/../utils/common/logging.sh"
source "${script_dir}/../utils/common/prompt.sh"
source "${script_dir}/../utils/common/execution.sh"
```

**macOS install scripts:**
```bash
source "${script_dir}/../utils/macos/utils.sh"
```

**Ubuntu install scripts:**
```bash
source "${script_dir}/../utils/ubuntu/utils.sh"
```

**Raspberry Pi OS install scripts:**
```bash
source "${script_dir}/../utils/ubuntu/utils.sh"  # Uses same apt functions
```

### Version-Specific Utilities

Currently, none of the utility functions are version-specific. All functions work across versions:

- **Common utilities** work on all OSes
- **Homebrew functions** work on all macOS versions (14, 15, etc.)
- **APT functions** work on all Ubuntu versions (20, 22, 23, 24) and editions (svr, wks, wsl)

**If future version-specific utilities are needed**, they would go in:
- `src/utils/ubuntu-24/utils.sh` - Ubuntu 24-specific utilities
- `src/utils/macos-14/utils.sh` - macOS Sonoma-specific utilities
- etc.

### Edition-Specific Utilities

Currently, none of the utility functions are edition-specific (server vs workstation). All functions work across editions.

**If future edition-specific utilities are needed**, they would go in:
- `src/utils/ubuntu-24-svr/utils.sh` - Server-specific utilities
- `src/utils/ubuntu-24-wks/utils.sh` - Workstation-specific utilities
- etc.

### Functions NOT to Migrate

These are handled by Oh My Bash or are obsolete:
- Custom prompt functions (Oh My Bash themes handle this)
- Git branch parsing (Oh My Bash Git plugin)
- Custom autocomplete (Oh My Bash completions)
- Travis CI specific code (obsolete)

## Notes

1. **Error Handling:** Most functions use `execute()` which provides consistent error handling and user feedback.

2. **Quiet Operations:** Package manager functions use quiet flags (`-qq`, `&> /dev/null`) to reduce output noise.

3. **Idempotency:** Installation functions check if software is already installed before attempting installation.

4. **User Feedback:** All operations provide clear success/error messages with checkmarks/X symbols.

5. **sudo Management:** `ask_for_sudo()` keeps sudo alive in background, preventing repeated password prompts.

6. **Version Independence:** apt utility functions are identical across Ubuntu 20, 22, 23, 24, and Raspberry Pi OS.

## Usage Pattern Example

```bash
#!/bin/bash

# Source utilities
cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils/common/utils.sh" \
    && . "../../utils/ubuntu/utils.sh"

main() {
    print_in_purple "\n • Installing Essential Packages\n\n"

    # Get sudo upfront
    ask_for_sudo

    # Update package index
    update

    # Install packages
    install_package "Build Essential" "build-essential"
    install_package "Git" "git"

    # Upgrade existing packages
    upgrade

    # Clean up
    autoremove
}

main "$@"
```
