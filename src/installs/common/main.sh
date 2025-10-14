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

    # Phase 2.1: Install Oh My Bash
    print_in_purple "\n   • Install Oh My Bash\n\n"

    if [ -d "$HOME/.oh-my-bash" ]; then
        print_success "Oh My Bash already installed"
    else
        execute \
            "bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)\" --unattended" \
            "Install Oh My Bash"
    fi

    # Phase 2.2: Install NVM and Node.js
    print_in_purple "\n   • Install NVM and Node.js\n\n"

    # NVM directory and config file
    local nvm_dir="${NVM_DIR:-$HOME/.nvm}"
    local bash_local="$HOME/.bash.local"

    if [ ! -d "$nvm_dir" ]; then
        execute \
            "git clone https://github.com/nvm-sh/nvm.git $nvm_dir" \
            "Install NVM"
    else
        print_success "NVM already installed"
    fi

    # Add NVM configuration to .bash.local and source it
    # (Following legacy pattern: add config AND source in one execute command)
    if ! grep -q "NVM_DIR" "$bash_local" 2>/dev/null; then
        execute \
            "printf '%s\n' '' \
                '# NVM configuration (for installation scripts)' \
                'export NVM_DIR=\"\$HOME/.nvm\"' \
                '[ -s \"\$NVM_DIR/nvm.sh\" ] && \\. \"\$NVM_DIR/nvm.sh\"' \
                '[ -s \"\$NVM_DIR/bash_completion\" ] && \\. \"\$NVM_DIR/bash_completion\"' \
                >> $bash_local \
                && . $bash_local" \
            "Configure NVM in .bash.local"
    fi

    # Install Node.js 22 (source .bash.local to get NVM in the subshell)
    execute \
        ". $bash_local && nvm install 22" \
        "Install Node.js 22"

    execute \
        ". $bash_local && nvm alias default 22" \
        "Set Node.js 22 as default"

    # Phase 2.3: Update npm
    print_in_purple "\n   • Update npm\n\n"

    # Source .bash.local then update npm
    # NVM should auto-activate the default version when sourced
    execute \
        ". $bash_local && npm install --global --silent npm@latest" \
        "Update npm to latest"

    print_in_green "\n   Common installations complete\n\n"

}

main "$@"
