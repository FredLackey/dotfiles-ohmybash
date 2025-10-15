#!/bin/bash

# macOS Software Installation Script
# Installs Homebrew and core packages for macOS

main() {

    # All variables go inside this main() function
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Source utilities
    . "${script_dir}/../../utils/common/utils.sh"
    . "${script_dir}/../../utils/common/logging.sh"
    . "${script_dir}/../../utils/common/execution.sh"
    . "${script_dir}/../../utils/macos/utils.sh"

    # Phase 2.1: Install Homebrew
    print_in_purple "\n   • Install Homebrew\n\n"
    
    install_homebrew
    opt_out_of_homebrew_analytics
    
    # Update and upgrade Homebrew
    print_in_yellow "   Updating Homebrew...\n\n"
    brew_update
    brew_upgrade

    # Phase 2.2: Install Core Packages
    print_in_purple "\n   • Install Core Packages\n\n"
    
    print_in_yellow "   Installing Git...\n\n"
    brew_install "Git" "git"
    
    print_in_yellow "   Installing tmux...\n\n"
    brew_install "tmux" "tmux"
    brew_install "Pasteboard" "reattach-to-user-namespace"
    
    print_in_yellow "   Installing Vim...\n\n"
    brew_install "Vim" "vim"

    print_in_green "\n   macOS installations complete\n\n"

}

main "$@"
