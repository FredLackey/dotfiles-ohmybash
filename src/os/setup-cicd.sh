#!/bin/bash

# CI/CD Setup Script
# 
# This script is a wrapper for setup.sh that automatically answers "yes" to all
# prompts, making it suitable for automated deployments, containers, and CI/CD
# pipelines.
#
# Usage:
#   ./setup-cicd.sh
#
# This is equivalent to:
#   ./setup.sh -y

cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1

./setup.sh -y

