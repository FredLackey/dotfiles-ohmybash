#!/bin/bash

# File to be sourced by other scripts
# Raspberry Pi OS 4 Server specific utilities

# Source Raspberry Pi OS family utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/../pios/utils.sh"