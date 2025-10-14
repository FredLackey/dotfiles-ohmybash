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

    if [ ! -d "$HOME/.nvm" ]; then
        execute \
            "git clone https://github.com/nvm-sh/nvm.git $HOME/.nvm" \
            "Install NVM"

        # Add NVM configuration to .bash.local
        if ! grep -q "NVM_DIR" "$HOME/.bash.local" 2>/dev/null; then
            cat >> "$HOME/.bash.local" <<'EOF'

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF
        fi
    else
        print_success "NVM already installed"
    fi

    # Install Node.js 22 (source .bash.local inside execute like legacy)
    execute \
        ". $HOME/.bash.local && nvm install 22" \
        "Install Node.js 22"

    execute \
        ". $HOME/.bash.local && nvm alias default 22" \
        "Set Node.js 22 as default"

    # Phase 2.3: Update npm
    print_in_purple "\n   • Update npm\n\n"

    # Source .bash.local inside execute (following legacy pattern)
    execute \
        ". $HOME/.bash.local && npm install --global --silent npm@latest" \
        "Update npm to latest"

    print_in_green "\n   Common installations complete\n\n"

}

main "$@"
