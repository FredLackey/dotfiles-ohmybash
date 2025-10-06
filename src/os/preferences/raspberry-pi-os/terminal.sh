#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Terminal\n\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set default terminal
execute \
    "sudo update-alternatives --set x-terminal-emulator /usr/bin/lxterminal" \
    "Set default terminal"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Configure terminal colors for better visibility
execute \
    "echo 'export TERM=xterm-256color' | sudo tee -a /etc/environment" \
    "Set terminal type"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Increase terminal scrollback buffer
execute \
    "echo 'set-option -g history-limit 10000' | sudo tee -a /etc/tmux.conf" \
    "Increase tmux scrollback buffer"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set terminal font for better readability
execute \
    "echo 'set -g default-terminal \"screen-256color\"' | sudo tee -a /etc/tmux.conf" \
    "Set tmux terminal type"
