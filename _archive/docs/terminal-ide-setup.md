# Terminal IDE Setup Guide

This guide walks you through building a **terminal-based IDE** using **NeoVim**, **LazyVim**, **tmux**, and **Zsh** with a modern prompt.

---

## 1) Install Core Tools

### macOS (Homebrew)
```bash
brew install neovim tmux fzf ripgrep node
```

### Ubuntu/Debian
```bash
sudo apt update
sudo apt install -y neovim tmux fzf ripgrep nodejs npm
```

---

## 2) Install NeoVim
Verify installation:
```bash
nvim --version
```

---

## 3) Install LazyVim
Backup old config if it exists:
```bash
mv ~/.config/nvim ~/.config/nvim.backup
```

Clone the starter config:
```bash
git clone https://github.com/LazyVim/starter ~/.config/nvim
```

Run NeoVim once to bootstrap:
```bash
nvim
```

---

## 4) Install tmux
Start a session:
```bash
tmux
```

Useful keys:
- `Ctrl-b c` → new window  
- `Ctrl-b n/p` → next/previous window  
- `Ctrl-b %` → split vertically  
- `Ctrl-b "` → split horizontally  
- `Ctrl-b d` → detach session  

---

## 5) Zsh + Prompt

### Make Zsh your default shell
```bash
zsh --version
chsh -s $(which zsh)
```

### Option A: Oh My Zsh + Powerlevel10k
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git   ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

Set the theme in `~/.zshrc`:
```zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
```
Restart the shell:
```bash
exec zsh
```

### Option B: Starship (cross‑shell prompt)
```bash
curl -sS https://starship.rs/install.sh | sh
```
Add to `~/.zshrc`:
```bash
eval "$(starship init zsh)"
```
Config file: `~/.config/starship.toml`

---

## 6) Recommended TUIs
- **lazygit** (Git UI)
  ```bash
  brew install lazygit       # macOS
  sudo apt install lazygit   # Ubuntu
  ```
- **yazi** or **ranger** (file manager)
- **btop** (system monitor)
- **fzf** and **ripgrep** (used by many tools)

---

## 7) Next Steps
- Tweak LazyVim under `~/.config/nvim`.
- Use tmux for project/session management.
- Consider enabling **Powerlevel10k Instant Prompt** for faster startup.
- Add TUIs as needed (lazygit, yazi/ranger, btop).

---

## Summary
- **NeoVim**: editor core  
- **LazyVim**: preconfigured IDE setup  
- **tmux**: panes & sessions  
- **Zsh + Powerlevel10k or Starship**: modern prompt  
- **fzf, ripgrep, lazygit, yazi**: productivity boosters
