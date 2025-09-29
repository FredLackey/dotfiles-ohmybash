softwareupdate --install-rosetta
needs to answer A to accept the agreement

echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc


----

Install NeoVim
brew install neovim

Install LazyVim inide of NeoVim
git clone https://github.com/LazyVim/starter ~/.config/nvim

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
Edit ~/.zshrc:
ZSH_THEME="powerlevel10k/powerlevel10k"
exec zsh
brew install lazygit   # macOS


