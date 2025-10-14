#!/bin/bash

# File to be sourced by other scripts
# Raspberry Pi OS utilities (Debian-based, uses apt like Ubuntu)

# Source Ubuntu utilities (Raspberry Pi OS uses apt)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/../ubuntu/utils.sh"