#!/usr/bin/env bash
set -e

# === CONFIG ===
NVIM_REPO_URL="https://github.com/yeasinjabed2/neovim_config.git"
NVIM_BRANCH="master"

# === SYSTEM SETUP ===
echo "🔧 Updating system..."
sudo apt update -y && sudo apt upgrade -y

echo "📦 Installing essential packages..."
sudo apt install -y git curl wget unzip build-essential pkg-config cmake ninja-build \
  ripgrep fd-find python3 python3-pip luarocks shellcheck

echo "📦 Installing Node.js (with npm) from NodeSource..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
echo "🔗 Linking fd command..."
mkdir -p ~/.local/bin
if ! command -v fd &>/dev/null; then
  ln -sf "$(which fdfind)" ~/.local/bin/fd
  export PATH="$HOME/.local/bin:$PATH"
fi

echo "🧠 Installing Python and Lua linters..."
pip install --upgrade pip
pip install flake8
sudo luarocks install luacheck

echo "🔧 Installing eslint_d for JavaScript/TypeScript linting..."
sudo npm install -g eslint_d

echo "🧰 Installing latest Neovim..."
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
if ! grep -q "nvim-linux-x86_64/bin" ~/.bashrc; then
  echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc
fi
nvim --version | head -n 1

# === LAZYGIT ===
# echo "🐙 Installing LazyGit..."
# sudo add-apt-repository ppa:lazygit-team/release
# sudo apt update
# sudo apt install lazygit -y
# lazygit --version

# === NEOVIM CONFIG ===
echo "🧩 Installing your Neovim config from GitHub..."
rm -rf ~/.config/nvim
git clone --branch "$NVIM_BRANCH" "$NVIM_REPO_URL" ~/.config/nvim --depth 1

# === PLUGIN SYNC ===
echo "🚀 Syncing Lazy.nvim plugins..."
nvim --headless "+Lazy! sync" +qa || true

echo "✅ All done!"
echo
echo "Next steps:"
echo "1️⃣ Restart your shell:  source ~/.bashrc"
echo "2️⃣ Open Neovim:         nvim"
echo "3️⃣ Run:                 :checkhealth"
echo
echo "Happy hacking with Neovim 💻"
