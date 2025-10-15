#!/bin/bash

# Common Software Installation Script
# Installs software packages that are universal across all operating systems

main() {

    # All variables go inside this main() function
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Source utilities
    . "${script_dir}/../../utils/common/utils.sh"
    . "${script_dir}/../../utils/common/logging.sh"
    . "${script_dir}/../../utils/common/execution.sh"

    # Phase 2.1: Install NVM and Node.js
    # Following legacy pattern: profile files exist now, NVM installer can configure them
    print_in_purple "\n   • Install NVM and Node.js\n\n"

    local nvm_dir="${NVM_DIR:-$HOME/.nvm}"

    # Install NVM using official install script
    if [ ! -d "$nvm_dir" ]; then
        print_in_yellow "   Installing NVM...\n\n"

        # Use curl or wget depending on what's available
        if command -v curl &> /dev/null; then
            execute \
                "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash" \
                "Install NVM"
        elif command -v wget &> /dev/null; then
            execute \
                "wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash" \
                "Install NVM"
        else
            print_error "Neither curl nor wget is available"
            exit 1
        fi
    else
        print_success "NVM already installed"
    fi

    # Source NVM for current script
    export NVM_DIR="$nvm_dir"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Install Node.js 22
    print_in_yellow "   Installing Node.js 22...\n\n"
    execute \
        "export NVM_DIR=\"${nvm_dir}\" && [ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\" && nvm install 22" \
        "Install Node.js 22"

    # Update npm to latest
    print_in_yellow "   Updating npm...\n\n"
    execute \
        "export NVM_DIR=\"${nvm_dir}\" && [ -s \"\$NVM_DIR/nvm.sh\" ] && . \"\$NVM_DIR/nvm.sh\" && npm install --global --silent npm@latest" \
        "Update npm to latest"

    # Phase 2.2: Install Oh My Bash
    print_in_purple "\n   • Install Oh My Bash\n\n"

    if [ -d "$HOME/.oh-my-bash" ]; then
        print_success "Oh My Bash already installed"
    else
        execute \
            "bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)\" --unattended" \
            "Install Oh My Bash"
    fi

    print_in_green "\n   Common installations complete\n\n"

}

main "$@"
