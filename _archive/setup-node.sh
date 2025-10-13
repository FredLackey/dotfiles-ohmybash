#!/bin/bash

# setup-node.sh - Simplified Node.js setup script
# Installs NVM, Node.js v20, and Claude Code

set -e

echo "🚀 Setting up Node.js development environment..."

# Install NVM if not already installed
if [ ! -d "$HOME/.nvm" ]; then
    echo "📦 Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
else
    echo "✅ NVM already installed"
fi

# Check if NVM is properly exported in profile
if ! grep -q "NVM_DIR" ~/.zshrc 2>/dev/null; then
    echo "📝 Adding NVM configuration to shell profile..."
    echo "" >> ~/.zshrc
    echo "# NVM Configuration" >> ~/.zshrc
    echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zshrc
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc
else
    echo "✅ NVM already configured in shell profile"
fi

# Source NVM for current session if not already available
if ! command -v nvm >/dev/null 2>&1; then
    echo "📝 Sourcing NVM for current session..."
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
    echo "✅ NVM already available in current session"
fi

# Install and use Node.js v20 if not already installed
if ! nvm list | grep -q "v20"; then
    echo "📦 Installing Node.js v20..."
    nvm install 20
    nvm use 20
    nvm alias default 20
else
    echo "✅ Node.js v20 already installed"
    nvm use 20
fi

# Update npm to latest version if needed
CURRENT_NPM_VERSION=$(npm --version)
LATEST_NPM_VERSION=$(npm view npm version)
if [ "$CURRENT_NPM_VERSION" != "$LATEST_NPM_VERSION" ]; then
    echo "📦 Updating npm from $CURRENT_NPM_VERSION to $LATEST_NPM_VERSION..."
    npm install -g npm@latest
else
    echo "✅ npm is already at latest version ($CURRENT_NPM_VERSION)"
fi

# Install Claude Code if not already installed
if ! npm list -g @anthropic-ai/claude-code >/dev/null 2>&1; then
    echo "📦 Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code
else
    echo "✅ Claude Code already installed"
fi

# Ensure global npm bin directory is in PATH
NPM_BIN_DIR=$(npm config get prefix)/bin
if ! echo "$PATH" | grep -q "$NPM_BIN_DIR"; then
    echo "📝 Adding npm global bin directory to PATH..."
    echo "" >> ~/.zshrc
    echo "# Add npm global bin directory to PATH" >> ~/.zshrc
    echo "export PATH=\"$NPM_BIN_DIR:\$PATH\"" >> ~/.zshrc
    export PATH="$NPM_BIN_DIR:$PATH"
else
    echo "✅ npm global bin directory already in PATH"
fi

echo "✅ Node.js setup complete!"
echo "Node version: $(node --version)"
echo "NPM version: $(npm --version)"
echo "NVM version: $(nvm --version)"

# Verify Claude Code installation
echo "🔍 Verifying Claude Code installation..."
if command -v claude >/dev/null 2>&1; then
    echo "✅ Claude Code is installed and accessible"
    echo "Claude version: $(claude --version 2>/dev/null || echo 'version check failed')"
else
    echo "❌ Claude Code command not found. You may need to restart your terminal or run:"
    echo "   source ~/.zshrc"
    echo "   or"
    echo "   export PATH=\"$NPM_BIN_DIR:\$PATH\""
fi
