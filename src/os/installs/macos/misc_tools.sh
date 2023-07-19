#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n   Miscellaneous Tools\n\n"

brew_install "ShellCheck" "shellcheck"

if [ -d "$HOME/.nvm" ]; then
    brew_install "Yarn" "yarn"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

brew_install "Adobe Creative Cloud" "adobe-creative-cloud" "--cask"
brew_install "AppCleaner" "appcleaner" "--cask"
brew_install "AWS CLI" "awscli"
brew_install "Beyond Compare" "beyond-compare" "--cask"
brew_install "Caffeine" "caffeine" "--cask"
# brew_install "Camtasia" "camtasia" "--cask"
brew_install "Cloud Mounter" "cloudmounter" "--cask"
brew_install "DataGrip" "datagrip" "--cask"
brew_install "DbSchema" "dbschema" "--cask"
# brew_install "Docker" "docker"
brew_install "DitialOcean Client API Tool" "doctl"
brew_install "Divvy" "divvy" "--cask"
brew_install "Draw.IO" "drawio" "--cask"
# brew_install "Dropbox" "dropbox" "--cask"
brew_install "Elmedia Player" "elmedia-player" "--cask"
brew_install "Evernote" "evernote" "--cask"
# brew_install "Shottr" "shottr" "--cask"
# brew_install "Signal" "signal" "--cask"
brew_install "Skype" "skype" "--cask"
brew_install "Slack" "slack" "--cask"
# brew_install "Snagit" "snagit" "--cask"
brew_install "Spotify" "spotify" "--cask"
brew_install "Studio 3T" "studio-3t" "--cask"
brew_install "Sublime Text" "sublime-text"
brew_install "Postman" "postman"
# brew_install "Python" "python"
brew_install "ngrok" "ngrok" "--cask"
brew_install "Nord Pass" "nordpass" "--cask"
brew_install "Nord VPN" "nordvpn" "--cask"
brew_install "Microsoft Office 365" "microsoft-office" "--cask"
brew_install "Microsoft Teams" "microsoft-teams" "--cask"
brew_install "MySQL Workbench" "mysqlworkbench" "--cask"
brew_install "Terimus" "termius" "--cask"
brew_install "Terraform" "terraform"
brew_install "yt-dlp" "yt-dlp"
brew_install "Zoom" "zoom" "--cask"

# if [ ! -d "ls -l /usr/local/bin/python" ]; then
#   execute \
#       "sudo ln -s -f /opt/homebrew/bin/python3 /usr/local/bin/python" \
#       "Set Python3 to default"
# fi


