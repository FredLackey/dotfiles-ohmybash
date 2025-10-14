#!/bin/bash

# Common Software Installation Script
# Installs software packages that are universal across all operating systems
#
# NOTE: NVM and Node.js are now installed in Phase 0.9 of setup.sh
# as critical dependencies before this phase runs.

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

    print_in_green "\n   Common installations complete\n\n"

}

main "$@"
