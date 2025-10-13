#!/bin/bash

# set-dotfiles.sh
# Sets up shell aliases and functions by copying dotfiles and ensuring they're sourced

set -e  # Exit on any error

main() {
    echo "Setting up shell aliases and functions..."

    # IMPORTANT: If the ~/.zshrc or ~/.bashrc files are symlinks do not touch them!

    # Get the directory where this script is located
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    FILES_DIR="$SCRIPT_DIR/files/shell"

    # Check if the files directory exists
    if [ ! -d "$FILES_DIR" ]; then
        echo "Error: Files directory not found at $FILES_DIR"
        exit 1
    fi

    # Copy ./files/shell/dot-aliases to ~/.aliases
    if [ -f "$FILES_DIR/dot-aliases" ]; then
        echo "Copying aliases to ~/.aliases..."
        cp "$FILES_DIR/dot-aliases" "$HOME/.aliases"
        chmod 644 "$HOME/.aliases"
        echo "✓ Aliases copied successfully"
    else
        echo "Warning: dot-aliases file not found at $FILES_DIR/dot-aliases"
    fi

    # Copy ./files/shell/dot-functions.sh to ~/.functions
    if [ -f "$FILES_DIR/dot-functions.sh" ]; then
        echo "Copying functions to ~/.functions..."
        cp "$FILES_DIR/dot-functions.sh" "$HOME/.functions"
        chmod 644 "$HOME/.functions"
        echo "✓ Functions copied successfully"
    else
        echo "Warning: dot-functions.sh file not found at $FILES_DIR/dot-functions.sh"
    fi

    # Ensure the ~/.zshrc and ~/.bashrc source ~/.aliases
    # Example: [ -f "$HOME/.aliases" ] && . "$HOME/.aliases"
    setup_bashrc
    setup_zshrc

    # Ensure the ~/.zshrc and ~/.bashrc source ~/.functions
    # Example: [ -f "$HOME/.functions" ] && . "$HOME/.functions"
    # (This is handled in the setup functions above)

    echo ""
    echo "Setup complete! Please restart your shell or run:"
    echo "  source ~/.bashrc   # for bash"
    echo "  source ~/.zshrc    # for zsh"
}

setup_bashrc() {
    local bashrc_file="$HOME/.bashrc"
    
    # Check if ~/.bashrc is a symlink (don't modify symlinks)
    if [ -L "$bashrc_file" ]; then
        echo "Warning: ~/.bashrc is a symlink, skipping modification"
        return
    fi

    # Create ~/.bashrc if it doesn't exist
    if [ ! -f "$bashrc_file" ]; then
        echo "Creating ~/.bashrc..."
        touch "$bashrc_file"
    fi

    # Add sourcing lines if they don't exist
    add_source_line "$bashrc_file" "aliases"
    add_source_line "$bashrc_file" "functions"
}

setup_zshrc() {
    local zshrc_file="$HOME/.zshrc"
    
    # Check if ~/.zshrc is a symlink (don't modify symlinks)
    if [ -L "$zshrc_file" ]; then
        echo "Warning: ~/.zshrc is a symlink, skipping modification"
        return
    fi

    # Create ~/.zshrc if it doesn't exist
    if [ ! -f "$zshrc_file" ]; then
        echo "Creating ~/.zshrc..."
        touch "$zshrc_file"
    fi

    # Add sourcing lines if they don't exist
    add_source_line "$zshrc_file" "aliases"
    add_source_line "$zshrc_file" "functions"
}

add_source_line() {
    local config_file="$1"
    local file_type="$2"
    local source_line="[ -f \"\$HOME/.$file_type\" ] && . \"\$HOME/.$file_type\""
    
    # Check if the source line already exists
    if grep -Fq "$source_line" "$config_file" 2>/dev/null; then
        echo "✓ ~/.$file_type already sourced in $(basename "$config_file")"
        return
    fi

    # Add the source line
    echo "" >> "$config_file"
    echo "# Source $file_type" >> "$config_file"
    echo "$source_line" >> "$config_file"
    echo "✓ Added ~/.$file_type sourcing to $(basename "$config_file")"
}

main "$@"