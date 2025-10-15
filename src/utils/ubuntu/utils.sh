#!/bin/bash

# File to be sourced by other scripts
# Ubuntu specific utilities

# Source Ubuntu family utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
. "${SCRIPT_DIR}/../debisn/utils.sh"