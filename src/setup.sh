#!/bin/bash

# Dotfiles Setup Script - Oh My Bash Edition
#
# Sets up development environment with dotfiles, installs required software,
# and configures system preferences using Oh My Bash as the foundation.
#
# Usage:
#   ./setup.sh          Interactive mode (asks for confirmation)
#   ./setup.sh -y       Non-interactive mode (auto-confirm all prompts)
#   ./setup.sh --yes    Same as -y
#
# Remote execution:
#   macOS:
#     curl -fsSL https://raw.githubusercontent.com/fredlackey/dotfiles-ohmybash/main/src/setup.sh | bash -s -- -y
#   Ubuntu/Raspberry Pi OS:
#     wget -qO - https://raw.githubusercontent.com/fredlackey/dotfiles-ohmybash/main/src/setup.sh | bash -s -- -y

# ------------------------------------------------------------------------------
# | Constants                                                                  |
# ------------------------------------------------------------------------------

declare -r GITHUB_REPOSITORY="fredlackey/dotfiles-ohmybash"

declare -r DOTFILES_ORIGIN="git@github.com:$GITHUB_REPOSITORY.git"
declare -r DOTFILES_TARBALL_URL="https://github.com/$GITHUB_REPOSITORY/tarball/main"
declare -r DOTFILES_UTILS_URL="https://raw.githubusercontent.com/$GITHUB_REPOSITORY/main/src/utils/common/utils.sh"

# ------------------------------------------------------------------------------
# | Helper Functions                                                           |
# ------------------------------------------------------------------------------

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

download_dotfiles() {

    local tmpFile=""
    local dotfilesDirectory="$1"
    local skipQuestions="$2"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_in_purple "\n • Download and extract archive\n\n"

    tmpFile="$(mktemp /tmp/XXXXX)"

    download "$DOTFILES_TARBALL_URL" "$tmpFile"
    print_result $? "Download archive" "true"
    printf "\n"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if ! $skipQuestions; then

        ask_for_confirmation "Do you want to store the dotfiles in '$dotfilesDirectory'?"

        if ! answer_is_yes; then
            dotfilesDirectory=""
            while [ -z "$dotfilesDirectory" ]; do
                ask "Please specify another location for the dotfiles (path): "
                dotfilesDirectory="$(get_answer)"
            done
        fi

        # Ensure the `dotfiles` directory is available

        while [ -e "$dotfilesDirectory" ]; do
            ask_for_confirmation "'$dotfilesDirectory' already exists, do you want to overwrite it?"
            if answer_is_yes; then
                rm -rf "$dotfilesDirectory"
                break
            else
                dotfilesDirectory=""
                while [ -z "$dotfilesDirectory" ]; do
                    ask "Please specify another location for the dotfiles (path): "
                    dotfilesDirectory="$(get_answer)"
                done
            fi
        done

        printf "\n"

    else

        rm -rf "$dotfilesDirectory" &> /dev/null

    fi

    mkdir -p "$dotfilesDirectory"
    print_result $? "Create '$dotfilesDirectory'" "true"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Extract archive in the `dotfiles` directory.

    extract "$tmpFile" "$dotfilesDirectory"
    print_result $? "Extract archive" "true"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    rm -rf "$tmpFile"
    print_result $? "Remove archive"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Change directory to the downloaded location (following legacy pattern)
    cd "$dotfilesDirectory/src" \
        || return 1

}

download_utils() {

    local tmpDir=""
    local utilFiles=("utils.sh" "logging.sh" "prompt.sh" "execution.sh")
    local baseUrl="https://raw.githubusercontent.com/$GITHUB_REPOSITORY/main/src/utils/common"

    tmpDir="$(mktemp -d)"

    # Download all utility files
    for file in "${utilFiles[@]}"; do
        download "$baseUrl/$file" "$tmpDir/$file" || {
            rm -rf "$tmpDir"
            return 1
        }
    done

    # Source all utility files in order
    . "$tmpDir/logging.sh" || return 1
    . "$tmpDir/prompt.sh" || return 1
    . "$tmpDir/utils.sh" || return 1
    . "$tmpDir/execution.sh" || return 1

    # Cleanup
    rm -rf "$tmpDir"

    return 0

}

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

# ------------------------------------------------------------------------------
# | Main                                                                       |
# ------------------------------------------------------------------------------

main() {

    # All variables go inside this main() function - no global scope pollution
    local dotfilesDirectory="$HOME/projects/dotfiles"
    local skipQuestions=false
    local script_dir=""
    local utils_dir=""
    local downloaded_dir=""

    # --------------------------------------------------------------------------
    # | PHASE 0: Bootstrap and Prerequisites                                   |
    # --------------------------------------------------------------------------

    # Step 0.1: Change to Script Directory
    # Ensure that all actions are relative to this file's path

    cd "$(dirname "${BASH_SOURCE[0]}")" \
        || exit 1

    script_dir="$(pwd)"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Step 0.2: Load or Download Utilities
    # Check if utility files exist locally, if not download them

    utils_dir="${script_dir}/utils/common"

    if [ -f "${utils_dir}/utils.sh" ] && \
       [ -f "${utils_dir}/logging.sh" ] && \
       [ -f "${utils_dir}/prompt.sh" ] && \
       [ -f "${utils_dir}/execution.sh" ]; then

        # Source all utility files
        . "${utils_dir}/utils.sh" || exit 1
        . "${utils_dir}/logging.sh" || exit 1
        . "${utils_dir}/prompt.sh" || exit 1
        . "${utils_dir}/execution.sh" || exit 1

    else

        # Download utilities remotely
        download_utils || exit 1

    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Step 0.3: Verify Operating System
    # Ensure the OS is supported and meets minimum version requirements

    verify_os \
        || exit 1

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Step 0.3a: Load OS-Specific Utilities
    # Source the most specific OS utils.sh file, which will chain-source the rest
    # Following SOURCE_PROCESS.md: setup.sh sources OS-specific utils.sh

    local os_name="$(get_os_name)"
    local os_utils_path="${utils_dir}/../${os_name}/utils.sh"

    # Source the most specific utils.sh file if it exists
    # The file will automatically chain-source up the hierarchy
    if [ -f "$os_utils_path" ]; then
        . "$os_utils_path"
    else
        # Fallback to OS family if specific edition doesn't exist
        local os_base="${os_name%%-*}"
        [ -f "${utils_dir}/../${os_base}/utils.sh" ] && . "${utils_dir}/../${os_base}/utils.sh"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Step 0.4: Parse Arguments
    # Check for -y or --yes flag to skip confirmation prompts

    skip_questions "$@" \
        && skipQuestions=true

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Step 0.5: Request Sudo Access
    # Request sudo password upfront and keep it alive

    ask_for_sudo

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Step 0.6: Download Dotfiles (If Remote Execution)
    # Check if this script was run directly (./<path>/setup.sh),
    # and if not, it means the dotfiles need to be downloaded

    printf "%s" "${BASH_SOURCE[0]}" | grep "setup.sh" &> /dev/null

    if [ $? -ne 0 ]; then
        # Script was NOT run directly (remote execution)
        download_dotfiles "$dotfilesDirectory" "$skipQuestions"

        # download_dotfiles already changed to the src directory (following legacy pattern)
        # Re-source utilities from the downloaded location
        utils_dir="utils/common"
        . "${utils_dir}/logging.sh" || exit 1
        . "${utils_dir}/prompt.sh" || exit 1
        . "${utils_dir}/utils.sh" || exit 1
        . "${utils_dir}/execution.sh" || exit 1

        # Re-source OS-specific utilities from the downloaded location
        # Source the most specific OS utils.sh file, which will chain-source the rest
        os_name="$(get_os_name)"
        local os_utils_path="${utils_dir}/../${os_name}/utils.sh"

        # Source the most specific utils.sh file if it exists
        # The file will automatically chain-source up the hierarchy
        if [ -f "$os_utils_path" ]; then
            . "$os_utils_path"
        else
            # Fallback to OS family if specific edition doesn't exist
            os_base="${os_name%%-*}"
            [ -f "${utils_dir}/../${os_base}/utils.sh" ] && . "${utils_dir}/../${os_base}/utils.sh"
        fi
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Step 0.7: Update Local Repository (If Git Repository)
    # Pull latest changes from GitHub if this is a git repository

    if is_git_repository; then
        print_in_purple "\n • Update local repository\n\n"
        execute "git pull --rebase" "Pull latest changes from GitHub"
    fi

    # --------------------------------------------------------------------------
    # | PHASE 0.8: Install Critical OS Prerequisites                          |
    # --------------------------------------------------------------------------
    #
    # CRITICAL: This phase must complete BEFORE any file operations.
    # These are foundational system tools required for git, compilation, etc.
    # This phase BLOCKS until all prerequisites are verified as installed.
    #
    # --------------------------------------------------------------------------

    print_in_purple "\n • Install critical OS prerequisites\n\n"

    if [ "$os_name" == "macos" ]; then
        # macOS: Xcode Command Line Tools (required for git, make, gcc, etc.)
        print_in_yellow "   Installing macOS prerequisites...\n\n"
        install_xcode_command_line_tools || {
            print_error "Failed to install Xcode Command Line Tools"
            print_error "This is required to continue. Please install manually and re-run."
            exit 1
        }
    else
        # Linux/Ubuntu/Raspberry Pi OS: build-essential and development tools
        print_in_yellow "   Installing Linux prerequisites...\n\n"
        install_linux_prerequisites || {
            print_error "Failed to install Linux prerequisites"
            print_error "This is required to continue. Please install manually and re-run."
            exit 1
        }
    fi

    print_in_green "\n   ✓ All critical OS prerequisites installed\n\n"

    # --------------------------------------------------------------------------
    # | PHASE 0.9: Install NVM and Node.js (CRITICAL DEPENDENCY)             |
    # --------------------------------------------------------------------------
    #
    # CRITICAL: Node.js is a fundamental dependency that must be available
    # before any other installations begin. This phase installs NVM (Node
    # Version Manager) and Node.js LTS, then validates that npm is accessible.
    # If this phase fails, the entire installation is aborted.
    #
    # --------------------------------------------------------------------------

    print_in_purple "\n • Install NVM and Node.js (Critical Dependency)\n\n"

    # NVM directory
    local nvm_dir="${NVM_DIR:-$HOME/.nvm}"

    # Install NVM using official install script (handles all configuration automatically)
    if [ ! -d "$nvm_dir" ]; then
        print_in_yellow "   Installing NVM via official installer...\n\n"
        execute \
            "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash" \
            "Install NVM" || {
            print_error "Failed to install NVM"
            print_error "NVM is required to continue. Please install manually and re-run."
            exit 1
        }
    else
        print_success "NVM already installed"
    fi

    # Source NVM in current shell
    export NVM_DIR="$nvm_dir"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # VALIDATE: Check if NVM is accessible
    if ! command -v nvm &> /dev/null && ! type nvm &> /dev/null; then
        print_error "NVM is not accessible after installation"
        print_error "This is a critical failure. Setup cannot continue."
        exit 1
    fi
    print_success "NVM is accessible"

    # Install Node.js LTS
    print_in_yellow "   Installing Node.js LTS...\n\n"
    execute \
        "nvm install --lts" \
        "Install Node.js LTS" || {
        print_error "Failed to install Node.js LTS"
        print_error "Node.js is required to continue. Please install manually and re-run."
        exit 1
    }

    # VALIDATE: Check if Node is accessible
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not accessible after installation"
        print_error "This is a critical failure. Setup cannot continue."
        exit 1
    fi
    local node_version=$(node --version)
    print_success "Node.js is accessible (${node_version})"

    # Set Node.js LTS as default
    execute \
        "nvm alias default lts/*" \
        "Set Node.js LTS as default" || {
        print_error "Failed to set Node.js LTS as default"
        exit 1
    }

    # VALIDATE: Check if default alias was created
    if ! nvm alias | grep -q "default"; then
        print_error "Failed to create default alias for Node.js"
        print_error "This is a critical failure. Setup cannot continue."
        exit 1
    fi
    print_success "Default alias set successfully"

    # Update npm to latest
    print_in_yellow "   Updating npm...\n\n"
    execute \
        "npm install --global --silent npm@latest" \
        "Update npm to latest" || {
        print_error "Failed to update npm"
        exit 1
    }

    # FINAL VALIDATION: Verify npm is still accessible after update
    if ! command -v npm &> /dev/null; then
        print_error "npm is not accessible after update"
        print_error "This is a critical failure. Setup cannot continue."
        exit 1
    fi
    local npm_version=$(npm --version)
    print_success "npm updated successfully (${npm_version})"

    print_in_green "\n   ✓ NVM, Node.js, and npm installation complete\n\n"

    # --------------------------------------------------------------------------
    # | PHASE 1: File System Setup                                            |
    # --------------------------------------------------------------------------


    # Step 1.1: Backup Original Bash Files
    # Backup existing .bash* files before creating symlinks

    print_in_purple "\n • Backup Original Bash Files\n\n"
    backup_bash_files

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Step 1.2: Create Symbolic Links
    # Create hierarchical symlinks from dotfiles to home directory

    print_in_purple "\n • Create symbolic links\n\n"
    create_symlinks "$@"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Step 1.3: Create Local Configuration Files
    # Create user-specific config files that are NOT tracked in Git

    print_in_purple "\n • Create local config files\n\n"
    create_bash_local
    create_gitconfig_local
    create_vimrc_local

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # --------------------------------------------------------------------------
    # | PHASE 2: Software Installation                                        |
    # --------------------------------------------------------------------------

    # Step 2.0: Execute Installation Hierarchy
    # Install software following hierarchy: common → OS family → version → edition

    print_in_purple "\n • Install software packages\n\n"

    # Build installation hierarchy
    local -a install_hierarchy=("common")

    if [ "$os_name" == "macos" ]; then
        install_hierarchy+=("macos")
    elif [ "$os_name" == "raspberry-pi-os" ]; then
        install_hierarchy+=("pios")
    else
        # Ubuntu variants
        local os_base="${os_name%%-*}"  # ubuntu
        local os_version="${os_name%-*}"  # ubuntu-24

        install_hierarchy+=("$os_base")

        if [ "$os_version" != "$os_base" ]; then
            install_hierarchy+=("$os_version")
        fi

        if [ "$os_version" != "$os_name" ]; then
            install_hierarchy+=("$os_name")
        fi
    fi

    # Execute installation scripts at each hierarchy level
    for level in "${install_hierarchy[@]}"; do
        local install_script="installs/${level}/main.sh"

        if [ -f "$install_script" ]; then
            print_in_purple "\n   • Installing ${level} packages\n\n"
            bash "$install_script"
        fi
    done

    # --------------------------------------------------------------------------
    # | PHASE 3: System Preferences Configuration                             |
    # --------------------------------------------------------------------------

    # TODO: Phase 3 will be implemented next
    print_in_purple "\n   Phase 3: System Preferences (Coming Soon)\n\n"

    # --------------------------------------------------------------------------
    # | PHASE 4: Oh My Bash Configuration                                     |
    # --------------------------------------------------------------------------

    # TODO: Phase 4 will be implemented next
    print_in_purple "\n   Phase 4: Oh My Bash Configuration (Coming Soon)\n\n"

    # --------------------------------------------------------------------------
    # | PHASE 5: Git Repository Initialization (Workstation/macOS Only)      |
    # --------------------------------------------------------------------------

    # TODO: Phase 5 will be implemented next
    print_in_purple "\n   Phase 5: Git Repository Init (Coming Soon)\n\n"

    # --------------------------------------------------------------------------
    # | PHASE 6: System Restart (Interactive Only)                           |
    # --------------------------------------------------------------------------

    # TODO: Phase 6 will be implemented next
    print_in_purple "\n   Phase 6: System Restart (Coming Soon)\n\n"

    # --------------------------------------------------------------------------

    print_in_green "\n   Setup completed successfully! \n\n"

}

main "$@"
