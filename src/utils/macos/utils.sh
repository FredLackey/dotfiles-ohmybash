#!/bin/bash

# File to be sourced by other scripts
# macOS-specific utility functions for Homebrew and package management

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

get_homebrew_git_config_file_path() {

    local path=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if path="$(brew --repository 2> /dev/null)/.git/config"; then
        printf "%s" "$path"
        return 0
    else
        print_error "Get config file path"
        return 1
    fi

}

install_homebrew() {

    if ! cmd_exists "brew"; then
        print_in_yellow "   Installing Homebrew...\n\n"
        execute \
            "NONINTERACTIVE=1 /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" \
            "Install Homebrew"
    else
        print_success "Homebrew already installed"
    fi

}

opt_out_of_homebrew_analytics() {

    local path=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Try to get the path of the `Homebrew` git config file.

    path="$(get_homebrew_git_config_file_path)" \
        || return 1

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Opt-out of Homebrew's analytics.
    # https://github.com/Homebrew/brew/blob/0c95c60511cc4d85d28f66b58d51d85f8186d941/share/doc/homebrew/Analytics.md#opting-out

    if [ "$(git config --file="$path" --get homebrew.analyticsdisabled)" != "true" ]; then
        git config --file="$path" --replace-all homebrew.analyticsdisabled true &> /dev/null
        print_result $? "Opt-out of Homebrew analytics"
    else
        print_success "Already opted out of Homebrew analytics"
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Xcode Command Line Tools
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

are_xcode_command_line_tools_installed() {
    xcode-select --print-path &> /dev/null
}

install_xcode_command_line_tools() {

    # If already installed, skip
    if are_xcode_command_line_tools_installed; then
        print_success "Xcode Command Line Tools already installed"
        return 0
    fi

    # If necessary, prompt user to install
    # the `Xcode Command Line Tools`.

    xcode-select --install &> /dev/null

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Wait until the `Xcode Command Line Tools` are installed.

    execute \
        "until are_xcode_command_line_tools_installed; do \
            sleep 5; \
         done" \
        "Install Xcode Command Line Tools"

}
