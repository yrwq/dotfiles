#!/bin/zsh

export GOPATH="$HOME/dev/go"
export PATH="$GOPATH/bin:$PATH"
export GTK_THEME="yrwqs_phocus"

# Change window title to current working directory
precmd() {
    print ""
    printf '\033]0;%s\007' "$(dirs)"
}

function preexec () {
    print ""
    print -n "\e[4 q"
}

# Completion {{{1
autoload -U compinit
compinit

setopt AUTO_LIST
setopt AUTO_MENU
setopt MENU_COMPLETE
setopt complete_in_word   # complete /v/c/a/p
setopt no_nomatch		  # enhanced bash wildcard completion
setopt magic_equal_subst
setopt noautoremoveslash
setopt null_glob

zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path $HOME/.cache/zsh
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select
zstyle ':completion:*:*:default' force-list always
zstyle ':completion:*' select-prompt '%SSelect:  lines: %L  matches: %M  [%p]'
zstyle ':completion:*:match:*' original only
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:predict:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'
zmodload zsh/complist
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:default' menu 'select=0'


HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.config/zsh/history

# Change cursor to _
print -n "\e[4 q"

bindkey -e
# key bindings
bindkey '^r' history-incremental-search-backward

bindkey '^p' up-history
bindkey '^n' down-history
bindkey '^l' autosuggest-accept

bindkey '^h' beginning-of-line
bindkey '^l' end-of-line
bindkey '^w' backward-kill-word
bindkey '^k' forward-char
bindkey '^j' backward-char
bindkey '^a' backward-word
bindkey '^d' forward-word


[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/tokens" ] && \
    source "${XDG_CONFIG_HOME:-$HOME/.config}/tokens"

# Fast syntax highlighting
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/fsh/fast-syntax-highlighting.plugin.zsh" ] && \
    source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/fsh/fast-syntax-highlighting.plugin.zsh"

alias \
    mv="mv -iv" \
    rm="rm -vI" \
    mkd="mkdir -pv" \
    ffmpeg="ffmpeg -hide_banner" \
    ls="exa" \
    l="exa -l" \
    la="exa -l -a" \
    grep="grep --color=auto" \
    diff="diff --color=auto" \
    bat="PAGER='' bat" \
    ga="git add" \
    gc="git commit -m" \
    gp="git push -u origin main" \
    mk="make && sudo make install" \
    f="$FILE" \
    v="nvim" \
    z="zathura"


alias \
    cf="cd /home/yrwq/.config && ls -a" \
    cfa="cd /home/yrwq/.config/awesome && ls -a" \
    cfv="cd /home/yrwq/.config/nvim && ls -a" \
    cfs="cd /home/yrwq/.config/shell && ls -a" \
    D="cd /home/yrwq/etc/dl && ls -a" \
    d="cd /home/yrwq/doc && ls -a" \
    m="cd /home/yrwq/etc/music && ls -a" \
    pp="cd /home/yrwq/etc/pic && ls -a" \
    sc="cd /home/yrwq/.local/bin && ls -a" \
    src="cd /home/yrwq/.local/src && ls -a" \
    vv="cd /home/yrwq/etc/vid && ls -a" \
    DD="cd /home/yrwq/dev/dotfiles && ls -a" \
    rr="cd /home/yrwq/etc/repos && ls -a" \
    bf="$EDITOR /home/yrwq/.config/shell/bm-files" \
    bd="$EDITOR /home/yrwq/.config/shell/bm-dirs" \
    cfz="$EDITOR /home/yrwq/.config/zsh/.zshrc" \
    cfu="$EDITOR /home/yrwq/.config/newsboat/urls" \
    cfl="$EDITOR /home/yrwq/.config/lf/lfrc" \
    cfr="$EDITOR /home/yrwq/.config/river/init" \
    cfh="$EDITOR /home/yrwq/.config/herbstluftwm/autostart" \

PROMPT="%B%F{1}%1~ %F{3}::%f%b "
