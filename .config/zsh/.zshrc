if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

autoload -Uz compinit
compinit

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle '*' single-ignored show

alias \
  cd="z" \
  y="yazi" \
  ls="eza --icons always" \
  l="ls -l" \
  la="ls -l -a" \
  ga="git add" \
  gc="git commit -m" \
  gp="git push -u" \
  lg="lazygit" \
  v="nvim"

alias \
  cfz="nvim $HOME/.config/zsh/.zshrc"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f "/Users/yrwq/.local/share/ghcup/.ghcup/env" ] && . "/Users/yrwq/.local/share/ghcup/.ghcup/env"
