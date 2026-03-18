sudo add-apt-repository ppa:git-core/ppa
sudo apt-add-repository ppa:fish-shell/release-4
sudo add-apt-repository ppa:neovim-ppa/unstable

sudo apt update
sudo apt upgrade -y

sudo apt install -y \
	software-properties-common \
	build-essential \
	git \
	curl \
	wget \
	fish \
	neovim \
	unzip \
	clang \
	libclang-dev \
	pkg-config \
	libssl-dev \
	jq

echo $(which fish) | sudo tee -a /etc/shells
chsh -s $(which fish)

curl -LsSf https://astral.sh/uv/install.sh | sh

curl -sfL https://direnv.net/install.sh | bash
echo "direnv hook fish | source" >> ~/.config/fish/config.fish

curl https://mise.run | sh
echo "/home/zxfv/.local/bin/mise activate fish | source" >> ~/.config/fish/config.fish

curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env.fish"

source $HOME/.local/bin/env.fish

mise use -g node@latest
mise use -g pnpm@latest
mise use -g fzf@latest
mise use -g fd@latest

cargo install --locked bat
set -Ux BAT_THEME "ansi"
cargo install --locked exa
cargo install --locked tree-sitter-cli

fisher install PatrickF1/fzf.fish

curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fisher install jethrokuan/z

wget -P ~/.config/fish/functions/ https://raw.githubusercontent.com/monodyle/dotfiles/refs/heads/master/.config/fish/functions/fish_prompt.fish

wget -O ~/.gitalias https://raw.githubusercontent.com/GitAlias/gitalias/main/gitalias.txt
echo -e "[include]\npath = ~/.gitalias" >> ~/.gitconfig

git clone https://github.com/NvChad/starter ~/.config/nvim

