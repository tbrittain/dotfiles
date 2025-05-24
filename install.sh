#!/bin/bash

set -e

echo "🔧 Updating packages..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing essential packages..."
sudo apt install -y \
    git \
    curl \
    wget \
    unzip \
    build-essential \
    zsh \
    neovim \
    jq

echo "📦 Installing lazygit from GitHub releases..."
LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name": "\K.*?(?=")')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit lazygit.tar.gz

echo "💡 Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "🔍 Backing up existing .zshrc if present..."
if [ -f "$HOME/.zshrc" ]; then
  mv "$HOME/.zshrc" "$HOME/.zshrc.bak"
fi

echo "🧩 Installing zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "🧩 Installing zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "📝 Creating a new .zshrc..."
cat <<EOF > "$HOME/.zshrc"
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source \$ZSH/oh-my-zsh.sh

# Source custom aliases
if [ -f "\$HOME/.aliases" ]; then
  source "\$HOME/.aliases"
fi
EOF

echo "🔗 Creating a default .aliases file..."
cat <<EOF > "$HOME/.aliases"
alias ll='ls -alF'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --all'
alias lg='lazygit'
EOF

echo "🔄 Changing default shell to Zsh..."
chsh -s $(which zsh)

echo "🛠️ Ensuring Zsh launches on WSL startup..."
ZSH_EXEC_SNIPPET='if [ -t 1 ] && [ -z "$ZSH_VERSION" ]; then\n  exec zsh\nfi'
if ! grep -q "exec zsh" "$HOME/.bashrc"; then
  echo -e "\n# Launch zsh automatically if not already in zsh\n$ZSH_EXEC_SNIPPET" >> "$HOME/.bashrc"
  echo "✅ Appended zsh auto-launch to ~/.bashrc"
else
  echo "ℹ️ Zsh exec already present in ~/.bashrc, skipping..."
fi

echo "Setting up GCM for use with WSL"
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
echo "Configured WSL mount to point to Windows GCM"

echo "✅ All done! Please restart your terminal or run 'zsh' to start using Zsh."
