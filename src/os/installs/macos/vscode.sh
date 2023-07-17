#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_plugin() {
    execute "code --install-extension $2" "$1 plugin"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Visual Studio Code\n\n"                                :

# Install VSCode
brew_install "Visual Studio Code" "visual-studio-code" "--cask"

printf "\n"

# Install the VSCode plugins
install_plugin "EditorConfig" "EditorConfig.EditorConfig"
install_plugin "File Icons" "vscode-icons-team.vscode-icons"
install_plugin "MarkdownLint" "DavidAnson.vscode-markdownlint"
# install_plugin "Vim" "vscodevim.vim"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_plugin "chouzz.vscode-better-align" "Better Align"
install_plugin "dracula-theme.theme-dracula" "Darkula Official Theme"
install_plugin "EditorConfig.EditorConfig" "ESLint Support"
install_plugin "dsznajder.es7-react-js-snippets" "ES7 React Snippets"
install_plugin "FerrierBenjamin.fold-unfold-all-icone" "Fold / Unfold All Icons"
install_plugin "GitHub.copilot" "GitHub CoPilot"
install_plugin "ritwickdey.LiveServer" "Live Server"
install_plugin "johnpapa.vscode-peacock" "Peacock"
install_plugin "esbenp.prettier-vscode" "Prettier"
install_plugin "Prisma.prisma" "Prisma"
install_plugin "vscode-icons-team.vscode-icons" "VSCode Icons"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# Close VSCode
osascript -e 'quit app "Visual Studio Code"'
