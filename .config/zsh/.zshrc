#!/bin/zsh

# Init completions
autoload -Uz compinit
compinit

# Change window title to current working directory
precmd() {
    printf '\033]0;%s\007' "$(dirs)"
}


# Completion settings
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle -e ':completion:*' special-dirs '[[ $PREFIX = (../)#(..) ]] && reply=(..)'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' format %F{yellow}%B%U%{$cfg[ITALIC_ON]%}%d%{$cfg[ITALIC_OFF]%}%b%u%f
zstyle ':completion:*' expand suffix
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true

zstyle ':completion:*' matcher-list '' '+m:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}' '+m:{_-}={-_}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# options
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

function zle-line-init () {
    echoti smkx
}

function zle-line-finish () {
    echoti rmkx
}

zle -N zle-line-init
zle -N zle-line-finish

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

print -n "\e[6 q"
function preexec () {
    print -n "\e[6 q"
}

export KEYTIMEOUT=1
bindkey ‘^R’ history-incremental-search-backward
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^K' autosuggest-accept

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" ] && \
    source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc"

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && \
    source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc" ] && \
    source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zshnameddirrc"

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/tokens" ] && \
    source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/tokens"


PS1="%(?.%F{red}.%F{green})%1~ %(?.%F{green}.%F{red})%(!.#.%(?. . ))%f "
RPS1="%(?.. %F{red}%B[%(?..%?)]%b)"
PS2="%F{magenta}%_ %F{green}>%F{white}%f "
