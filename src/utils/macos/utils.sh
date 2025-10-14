#!/bin/bash

# File to be sourced by other scripts
# macOS-specific utilities: Xcode, Homebrew package management

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/../common/utils.sh"
. "${SCRIPT_DIR}/../common/logging.sh"
. "${SCRIPT_DIR}/../common/prompt.sh"
. "${SCRIPT_DIR}/../common/execution.sh"

# ------------------------------------------------------------------------------
# | Xcode Command Line Tools                                                   |
# ------------------------------------------------------------------------------

install_xcode_command_line_tools() {

    # Check if Xcode Command Line Tools are already installed
    if xcode-select -p &> /dev/null; then
        print_success "Xcode Command Line Tools"
        return 0
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If not installed, trigger installation
    print_in_yellow "\n   Xcode Command Line Tools are required but not installed.\n"
    print_in_yellow "   A system dialog will appear.\n"
    print_in_yellow "   Please click 'Install' and wait for the download to complete.\n\n"

    # Trigger the installation dialog
    xcode-select --install 2>&1

    # Give the dialog time to appear
    sleep 2

    # Wait for installation to complete
    # Poll every 5 seconds until xcode-select -p succeeds
    print_in_purple "   Waiting for Xcode Command Line Tools installation to complete...\n"
    print_in_purple "   (This may take several minutes depending on your internet connection)\n\n"

    local attempt=0
    local max_attempts=360  # 30 minutes maximum (360 * 5 seconds)

    until xcode-select -p &> /dev/null; do
        attempt=$((attempt + 1))

        if [ $attempt -gt $max_attempts ]; then
            printf "\n"
            print_error "Xcode Command Line Tools installation timed out"
            print_error "Please install manually and re-run this script"
            return 1
        fi

        # Show progress every minute (12 attempts = 60 seconds)
        if [ $((attempt % 12)) -eq 0 ]; then
            printf "   Still waiting... (%d minutes elapsed)\n" $((attempt / 12))
        fi

        sleep 5
    done

    printf "\n"

    # Verify installation succeeded
    if xcode-select -p &> /dev/null; then
        print_success "Xcode Command Line Tools installed successfully"
        return 0
    else
        print_error "Xcode Command Line Tools installation verification failed"
        return 1
    fi

}

# ------------------------------------------------------------------------------
# | Homebrew Package Management                                                |
# ------------------------------------------------------------------------------

brew_install() {

    declare -r ARGUMENTS="$3"
    declare -r FORMULA="$2"
    declare -r FORMULA_READABLE_NAME="$1"
    declare -r TAP_VALUE="$4"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `Homebrew` is installed.

    if ! cmd_exists "brew"; then
        print_error "$FORMULA_READABLE_NAME ('Homebrew' is not installed)"
        return 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # If `brew tap` needs to be executed,
    # check if it executed correctly.

    if [ -n "$TAP_VALUE" ]; then
        if ! brew_tap "$TAP_VALUE"; then
            print_error "$FORMULA_READABLE_NAME ('brew tap $TAP_VALUE' failed)"
            return 1
        fi
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install the specified formula.

    # shellcheck disable=SC2086
    if brew list "$FORMULA" &> /dev/null; then
        print_success "$FORMULA_READABLE_NAME"
    else
        execute \
            "brew install $FORMULA $ARGUMENTS" \
            "$FORMULA_READABLE_NAME"
    fi

}

brew_prefix() {

    local path=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if path="$(brew --prefix 2> /dev/null)"; then
        printf "%s" "$path"
        return 0
    else
        print_error "Homebrew (get prefix)"
        return 1
    fi

}

brew_tap() {
    brew tap "$1" &> /dev/null
}

brew_update() {

    execute \
        "brew update" \
        "Homebrew (update)"

}

brew_upgrade() {

    execute \
        "brew upgrade" \
        "Homebrew (upgrade)"

}
