export GNUPGHOME="$HOME/.config/gnupg"
export NVM_DIR="$HOME/.local/share/nvm"
export BUN_INSTALL="$HOME/.local/share/bun"
export ZDOTDIR="$HOME/.config/zsh"
export CARGO_HOME="$HOME/.local/cargo"
export RUSTUP_HOME="$HOME/.local/rustup"
export DOCKER_CONFIG="$HOME/.config/docker"
export CODEX_HOME="$HOME/.config/codex"
export IONIC_CONFIG_DIRECTORY="$HOME/.config/ionic"
export ANTIGRAVITY_HOME="$HOME/.local/antigravity"
export GEMINI_HOME="$HOME/.local/gemini"
export GHCUP_INSTALL_BASE_PREFIX="$HOME/.local/share/ghcup"

export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$CARGO_HOME/bin:$PATH"

export MANPAGER="sh -c 'col -bx | bat -l man -p --paging always'"
export BAT_THEME="gruvbox-dark"

HISTFILE="$HOME/.local/history"

[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

eval "$(/opt/homebrew/bin/brew shellenv zsh)"
