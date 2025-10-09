# Bash Aliases by Operating System

This document lists all bash aliases defined across the different OS-specific configurations.

---

## Base Aliases (`src/shell/bash_aliases`)

**Navigation:**
- `..` → `cd ..`
- `...` → `cd ../..`
- `....` → `cd ../../..`
- `cd..` → `cd ..`

**File Operations:**
- `cp` → `cp -iv` (interactive, verbose)
- `mkdir` → `mkdir -pv` (create parents, verbose)
- `mv` → `mv -iv` (interactive, verbose)
- `rm` → `rm -rf --`

**Common Shortcuts:**
- `:q` → `exit`
- `c` → `clear`
- `ch` → `history -c && > ~/.bash_history`
- `d` → `cd ~/Desktop`
- `e` → `vim --`
- `g` → `git`
- `ip` → `dig +short myip.opendns.com @resolver1.opendns.com`
- `ll` → `ls -l`
- `m` → `man`
- `map` → `xargs -n1`
- `n` → `npm`
- `p` → `cd ~/projects`
- `path` → `printf "%b\n" "${PATH//:/\\n}"`
- `q` → `exit`
- `t` → `tmux`
- `y` → `yarn`

**Customizations:**
- `dp` → `docker ps --format '{{.ID}}\t{{.Names}}\t{{.Ports}}'`
- `iprisma` → `npm i --save-dev prisma@latest && npm i @prisma/client@latest`
- `count-files` → `find . -maxdepth 1 -type f | wc -l`
- `count-folders` → `find . -mindepth 1 -maxdepth 1 -type d | wc -l`
- `count` → `echo "Files  : $(find . -maxdepth 1 -type f | wc -l)" && echo "Folders: $(find . -mindepth 1 -maxdepth 1 -type d | wc -l)"`
- `rm` → `rm_safe` (overrides earlier rm alias)

**Note:** This file sources OS-specific aliases via `. "$OS/bash_aliases"`

---

## macOS (`src/shell/macos/bash_aliases`)

**System:**
- `afk` → `osascript -e 'tell application "System Events" to sleep'` (lock screen)

**Homebrew:**
- `brewd` → `brew doctor`
- `brewi` → `brew install`
- `brewr` → `brew uninstall`
- `brews` → `brew search`
- `brewu` → `brew update --quiet && brew upgrade && brew cleanup`

**System Maintenance:**
- `clear-dns-cache` → `sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder`
- `empty-trash` → `sudo rm -frv /Volumes/*/.Trashes; sudo rm -frv ~/.Trash; sudo rm -frv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'`

**Finder:**
- `hide-desktop-icons` → `defaults write com.apple.finder CreateDesktop -bool false && killall Finder`
- `show-desktop-icons` → `defaults write com.apple.finder CreateDesktop -bool true && killall Finder`
- `hide-hidden-files` → `defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder`
- `show-hidden-files` → `defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder`

**Utilities:**
- `o` → `open`
- `u` → `sudo softwareupdate --install --all && brew update && brew upgrade && brew cleanup`

**Customizations:**
- `iso` → `TZ=America/Los_Angeles date -Iseconds`
- `local-ip` → `ipconfig getifaddr en1`
- `ports` → `lsof -i -P -n`
- `iprisma` → `npm i --save-dev prisma@latest && npm i @prisma/client@latest`
- `code-all` → `find . -type d -depth 1 -exec code {} \;`
- `packages` → `find ./ -type f -name "package.json" -exec stat -f "%Sm %N" -t "%Y-%m-%d %H:%M:%S" {} + | grep -v "node_modules" | sort -n`

---

## Raspberry Pi OS (`src/shell/raspberry-pi-os/bash_aliases`)

**Base Aliases (Duplicated):**
- `..` → `cd ..`
- `...` → `cd ../..`
- `....` → `cd ../../..`
- `cd..` → `cd ..`
- `cp` → `cp -iv`
- `mkdir` → `mkdir -pv`
- `mv` → `mv -iv`
- `rm` → `rm -rf --`
- `:q` → `exit`
- `c` → `clear`
- `ch` → `history -c && > ~/.bash_history`
- `d` → `cd ~/Desktop`
- `e` → `vim --`
- `g` → `git`
- `ip` → `dig +short myip.opendns.com @resolver1.opendns.com`
- `ll` → `ls -l`
- `m` → `man`
- `map` → `xargs -n1`
- `n` → `npm`
- `p` → `cd ~/projects`
- `path` → `printf "%b\n" "${PATH//:/\\n}"`
- `q` → `exit`
- `t` → `tmux`
- `y` → `yarn`

**Customizations (Duplicated):**
- `dp` → `docker ps --format '{{.ID}}\t{{.Names}}\t{{.Ports}}'`
- `iprisma` → `npm i --save-dev prisma@latest && npm i @prisma/client@latest`
- `count-files` → `find . -maxdepth 1 -type f | wc -l`
- `count-folders` → `find . -mindepth 1 -maxdepth 1 -type d | wc -l`
- `count` → `echo "Files  : $(find . -maxdepth 1 -type f | wc -l)" && echo "Folders: $(find . -mindepth 1 -maxdepth 1 -type d | wc -l)"`
- `rm` → `rm_safe`

**APT (Advanced Packaging Tool):**
- `apti` → `sudo apt-get install`
- `aptr` → `sudo apt-get remove`
- `apts` → `sudo apt-cache search`
- `aptu` → `sudo apt-get update && sudo apt-get upgrade`

**System:**
- `u` → `sudo apt-get update && sudo apt-get upgrade`
- `packages` → `find ./ -type f -name "package.json" -exec stat --format="%Y %n" {} + | grep -v "node_modules" | sort -n | awk '{print strftime("%Y-%m-%d %H:%M:%S", $1), $2}'`

**Network:**
- `local-ip` → `hostname -I | awk '{print $1}'`
- `myip` → `curl -s https://ipinfo.io/ip`

**Raspberry Pi Specific:**
- `pi-temp` → `vcgencmd measure_temp`
- `pi-throttle` → `vcgencmd get_throttled`
- `pi-version` → `cat /proc/device-tree/model`

---

## Ubuntu 20 Server (`src/shell/ubuntu-20-svr/bash_aliases`)

**System:**
- `afk` → `gnome-screensaver-command --lock`

**APT (Advanced Packaging Tool):**
- `apti` → `sudo apt-get install`
- `aptr` → `sudo apt-get remove`
- `apts` → `sudo apt-cache search`
- `aptu` → `sudo apt-get update && sudo apt-get upgrade`

**System Maintenance:**
- `empty-trash` → `rm -rf ~/.local/share/Trash/files/*`
- `u` → `sudo apt-get update && sudo apt-get upgrade`

**Commented Out:**
- `hide-desktop-icons` → `gsettings set org.gnome.desktop.background show-desktop-icons false` (commented)
- `show-desktop-icons` → `gsettings set org.gnome.desktop.background show-desktop-icons true` (commented)
- `o` → `xdg-open` (commented)

**Customizations:**
- `dp` → `docker ps --format '{{.ID}}\t{{.Names}}\t{{.Ports}}'`
- `iprisma` → `npm i --save-dev prisma@latest && npm i @prisma/client@latest`
- `count-files` → `find . -maxdepth 1 -type f | wc -l`
- `count-folders` → `find . -mindepth 1 -maxdepth 1 -type d | wc -l`
- `count` → `echo "Files  : $(find . -maxdepth 1 -type f | wc -l)" && echo "Folders: $(find . -mindepth 1 -maxdepth 1 -type d | wc -l)"`
- `rm` → `rm_safe`
- `packages` → `find ./ -type f -name "package.json" -exec stat --format="%Y %n" {} + | grep -v "node_modules" sort -n | awk '{print strftime("%Y-%m-%d %H:%M:%S", $1), $2}'`
- `local-ip` → `hostname -I | awk '{print $1}'`

---

## Ubuntu 22 Server (`src/shell/ubuntu-22-svr/bash_aliases`)

**Identical to Ubuntu 20 Server** - All aliases are the same.

---

## Ubuntu 23 Server (`src/shell/ubuntu-23-svr/bash_aliases`)

**Identical to Ubuntu 20 Server** - All aliases are the same.

---

## Ubuntu 24 Server (`src/shell/ubuntu-24-svr/bash_aliases`)

**Identical to Ubuntu 20 Server** - All aliases are the same.

---

## Ubuntu 24 Workstation (`src/shell/ubuntu-24-wks/bash_aliases`)

**Identical to Ubuntu 20 Server** - All aliases are the same.

---

## Ubuntu Original (`src/shell/ubuntu-original/bash_aliases`)

**Identical to Ubuntu 20 Server** - All aliases are the same.

---

## Analysis & Issues

### Duplication Problems:

1. **All Ubuntu variants are identical** - There's no difference between ubuntu-20-svr, ubuntu-22-svr, ubuntu-23-svr, ubuntu-24-svr, ubuntu-24-wks, and ubuntu-original
2. **Base aliases duplicated in Raspberry Pi OS** - The raspberry-pi-os file contains all the base aliases that should be inherited from the parent bash_aliases file
3. **Customizations duplicated across all files** - Common Docker, count, and other custom aliases appear in multiple files

### Recommendations:

1. Create a single Ubuntu bash_aliases file that all Ubuntu variants can use
2. Remove duplicated base aliases from raspberry-pi-os (they should inherit from parent)
3. Consider moving common customizations (dp, iprisma, count-*, etc.) to the base bash_aliases file since they appear everywhere
4. Only keep truly OS-specific aliases in the OS-specific files

