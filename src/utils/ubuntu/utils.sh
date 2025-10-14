#!/bin/bash

# File to be sourced by other scripts
# All apt functions + repository management
# (used by all Ubuntu versions AND Raspberry Pi OS)

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/../common/utils.sh"
. "${SCRIPT_DIR}/../common/logging.sh"
. "${SCRIPT_DIR}/../common/prompt.sh"
. "${SCRIPT_DIR}/../common/execution.sh"

# ------------------------------------------------------------------------------
# | Critical System Prerequisites                                              |
# ------------------------------------------------------------------------------

install_linux_prerequisites() {

    # Update package lists first
    execute \
        "sudo apt-get update -qq" \
        "Update package lists"

    # Install build-essential (gcc, g++, make, libc-dev, etc.)
    if ! package_is_installed "build-essential"; then
        execute \
            "sudo apt-get install -y build-essential" \
            "Install build-essential"
    else
        print_success "build-essential"
    fi

    # Install git (version control)
    if ! cmd_exists "git"; then
        execute \
            "sudo apt-get install -y git" \
            "Install git"
    else
        print_success "git"
    fi

    # Install curl (HTTP client, needed for many downloads)
    if ! cmd_exists "curl"; then
        execute \
            "sudo apt-get install -y curl" \
            "Install curl"
    else
        print_success "curl"
    fi

    # Verify all critical tools are now available
    if ! cmd_exists "gcc" || ! cmd_exists "make" || ! cmd_exists "git" || ! cmd_exists "curl"; then
        print_error "Failed to install all required prerequisites"
        return 1
    fi

    return 0

}

# ------------------------------------------------------------------------------
# | APT Package Management                                                     |
# ------------------------------------------------------------------------------

add_key() {

    wget -qO - "$1" | sudo apt-key add - &> /dev/null
    #     │└─ write output to file
    #     └─ don't show output

}

add_ppa() {
    sudo add-apt-repository -y ppa:"$1" &> /dev/null
}

add_to_source_list() {
    sudo sh -c "printf 'deb $1' >> '/etc/apt/sources.list.d/$2'"
}

autoremove() {

    # Remove packages that were automatically installed to satisfy
    # dependencies for other packages and are no longer needed.

    execute \
        "sudo apt-get autoremove -qqy" \
        "APT (autoremove)"

}

install_package() {

    declare -r EXTRA_ARGUMENTS="$3"
    declare -r PACKAGE="$2"
    declare -r PACKAGE_READABLE_NAME="$1"

    if ! package_is_installed "$PACKAGE"; then
        execute "sudo apt-get install --allow-unauthenticated -qqy $EXTRA_ARGUMENTS $PACKAGE" "$PACKAGE_READABLE_NAME"
        #                                      suppress output ─┘│
        #            assume "yes" as the answer to all prompts ──┘
    else
        print_success "$PACKAGE_READABLE_NAME"
    fi

}

package_is_installed() {
    dpkg -s "$1" &> /dev/null
}

update() {

    # Resynchronize the package index files from their sources.

    execute \
        "sudo apt-get update -qqy" \
        "APT (update)"

}

upgrade() {

    # Install the newest versions of all packages installed.

    execute \
        "export DEBIAN_FRONTEND=\"noninteractive\" \
            && sudo apt-get -o Dpkg::Options::=\"--force-confnew\" upgrade -qqy" \
        "APT (upgrade)"

}
