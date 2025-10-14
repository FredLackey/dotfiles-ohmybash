#!/bin/bash

# File to be sourced by other scripts
# Ubuntu 24.04 specific utilities

# Source Ubuntu family utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/../ubuntu/utils.sh"