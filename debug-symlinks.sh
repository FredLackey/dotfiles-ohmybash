#!/bin/bash

# Debug script to check symlink setup after installation

echo "=== OS Detection ==="
echo "OS Name (get_os_name): $(cd ~/projects/dotfiles/src && bash -c 'source utils/common/utils.sh && get_os_name')"
echo "ProductVersion: $(sw_vers -productVersion)"
echo ""

echo "=== Symlink Status ==="
for file in bash_profile bash_aliases bash_functions bash_exports bash_options bashrc; do
    if [ -L "$HOME/.$file" ]; then
        target=$(readlink "$HOME/.$file")
        echo "✓ ~/.$file → $target"
    elif [ -f "$HOME/.$file" ]; then
        echo "✗ ~/.$file exists but is NOT a symlink (regular file)"
    else
        echo "✗ ~/.$file does NOT exist"
    fi
done
echo ""

echo "=== Checking if bash_functions file exists and has content ==="
if [ -f "$HOME/.bash_functions" ]; then
    lines=$(wc -l < "$HOME/.bash_functions")
    echo "✓ ~/.bash_functions exists with $lines lines"
    echo ""
    echo "First function:"
    grep -A 5 "^[a-z_]*() {" "$HOME/.bash_functions" | head -10
else
    echo "✗ ~/.bash_functions does NOT exist or is broken symlink"
fi
echo ""

echo "=== Checking if bash_profile sources bash_functions ==="
if grep -q "bash_functions" "$HOME/.bash_profile"; then
    echo "✓ bash_profile references bash_functions"
    grep "bash_functions" "$HOME/.bash_profile"
else
    echo "✗ bash_profile does NOT reference bash_functions"
fi
echo ""

echo "=== Testing if functions are actually loaded ==="
if declare -f dp > /dev/null 2>&1; then
    echo "✓ Function 'dp' is loaded"
else
    echo "✗ Function 'dp' is NOT loaded"
fi
echo ""

echo "=== Try manually sourcing bash_profile ==="
source "$HOME/.bash_profile"
if declare -f dp > /dev/null 2>&1; then
    echo "✓ After sourcing: Function 'dp' is NOW loaded"
else
    echo "✗ After sourcing: Function 'dp' is STILL NOT loaded"
fi
