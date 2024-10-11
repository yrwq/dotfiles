#!/bin/zsh

autoload -Uz compinit
compinit

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle '*' single-ignored show

setopt AUTO_CD
setopt RM_STAR_WAIT
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt AUTOPARAMSLASH
setopt SHARE_HISTORY

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.config/zsh/history

bindkey -v

function zle-keymap-select () {
  if
      [[ "$KEYMAP" == "vicmd" || "$1" = "block" ]]
  then
    print -n "\e[2 q"
  elif
      [[ "$KEYMAP" == "main" || "$KEYMAP" == "viins" || -z "$KEYMAP" || "$1" = "beam" ]]
  then
    print -n "\e[6 q"
  fi
}
zle -N zle-keymap-select

function zle-line-init () {
  zle -K viins
  print -n "\e[6 q"
}
zle -N zle-line-init

export KEYTIMEOUT=1
bindkey ‘^R’ history-incremental-search-backward
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^K' autosuggest-accept

bindkey -s '^F' "$HOME/.local/bin/edit\n"
bindkey -s '^O' "op\n"

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && \
    source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && \
    source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && \
    source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/tokens" ] && \
    source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/tokens"

# https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
[ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
    source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

PS1="%(?.%F{red}.%F{green})%1~ %(?.%F{green}.%F{red})%(!.#.%(?.:: .:: ))%f "
RPS1="%(?.. %F{red}%B[%(?..%?)]%b)"
PS2="%F{magenta}%_ %F{green}>%F{white}%f "

# bun completions
[ -s "/home/yrwq/.bun/_bun" ] && source "/home/yrwq/.bun/_bun"
