#!/bin/bash

# File to be sourced by other scripts
# macOS 14 (Sonoma) specific utilities

# Source macOS family utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/../macos/utils.sh"