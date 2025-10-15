#!/bin/bash

# Debian Software Installation Script
# Installs core packages for Debian-based systems

main() {

    # All variables go inside this main() function
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Source utilities
    . "${script_dir}/../../utils/common/utils.sh"
    . "${script_dir}/../../utils/common/logging.sh"
    . "${script_dir}/../../utils/common/execution.sh"
    . "${script_dir}/../../utils/debian/utils.sh"

    # Phase 2.1: Update package lists
    print_in_purple "\n   • Update Package Lists\n\n"
    update

    # Phase 2.2: Install Core Packages
    print_in_purple "\n   • Install Core Packages\n\n"

    print_in_yellow "   Installing Git...\n\n"
    install_package "Git" "git"

    print_in_yellow "   Installing tmux...\n\n"
    install_package "tmux" "tmux"

    print_in_yellow "   Installing NeoVim...\n\n"
    if ! command -v nvim &> /dev/null; then
        install_package "NeoVim" "neovim"
    else
        print_success "NeoVim is already installed"
    fi

    print_in_green "\n   Debian installations complete\n\n"

}

main "$@"