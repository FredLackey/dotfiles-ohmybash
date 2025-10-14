#!/bin/bash

# File to be sourced by other scripts
# Ubuntu 24.04 WSL specific utilities

# Source Ubuntu 24 version utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/../ubuntu-24/utils.sh"