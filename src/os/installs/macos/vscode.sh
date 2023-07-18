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
install_plugin "AWS Toolkit" "amazonwebservices.aws-toolkit-vscode"
install_plugin "Better Align" "chouzz.vscode-better-align"
install_plugin "Darkula Official Theme" "dracula-theme.theme-dracula"
install_plugin "Docker" "ms-azuretools.vscode-docker"
install_plugin "EditorConfig" "EditorConfig.EditorConfig"
install_plugin "ES7 React Snippets" "dsznajder.es7-react-js-snippets"
install_plugin "File Icons" "vscode-icons-team.vscode-icons"
install_plugin "Fold / Unfold All Icons" "FerrierBenjamin.fold-unfold-all-icone"
install_plugin "GitHub CoPilot" "GitHub.copilot"
install_plugin "Live Server" "ritwickdey.LiveServer"
install_plugin "MarkdownLint" "DavidAnson.vscode-markdownlint"
install_plugin "Peacock" "johnpapa.vscode-peacock"
install_plugin "Prettier" "esbenp.prettier-vscode"
install_plugin "Prisma" "Prisma.prisma"
# install_plugin "Vim" "vscodevim.vim"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Close VSCode
osascript -e 'quit app "Visual Studio Code"'
