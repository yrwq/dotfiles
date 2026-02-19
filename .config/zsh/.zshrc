setopt autocd
setopt correct
setopt no_beep
setopt interactive_comments
setopt extended_glob
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt share_history
setopt PROMPT_SUBST

HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$ZDOTDIR/history"

# https://github.com/yrwq/fr
function _edit() {
    nvim $(fr -c | fzf)
}

function _open() {
    cd $(fr -c | fzf)
}

zle -N _edit
zle -N _open

bindkey -e

bindkey '^F' _edit 
bindkey '^O' _open

bindkey '^R' history-incremental-search-backward
bindkey '^E' autosuggest-accept

bindkey '^A' beginning-of-line
bindkey '^D' end-of-line

bindkey '^J' backward-char
bindkey '^K' forward-char

bindkey '^H' backward-word
bindkey '^L' forward-word

bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

bindkey '^[w'  kill-word

#
# bootstrap zinit
#

ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

if [[ ! -d $ZINIT_HOME ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

#
# plugins
#

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

zinit light Aloxaf/fzf-tab

zinit load wfxr/forgit

#
# completion opts
#

fpath=(~/.local/share/zsh/completions $fpath)

autoload -Uz compinit
compinit

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

#
# alias
#

alias \
    cd="z" \
    y="yazi" \
    ls="eza --icons always" \
    l="ls -l" \
    la="ls -l -a" \
    gc="git commit -m" \
    gp="git push -u" \
    gs="gso" \
    gl="glo" \
    gg="gitu" \
    lg="lazygit" \
    v="nvim" \
    ft="ftdv"

alias \
  cfz="nvim $HOME/.config/zsh/.zshrc" \
  cfh="nvim $HOME/.config/hypr/hyprland.conf" \
  cfv="cd $HOME/.config/nvim" \
  cfs="nvim $HOME/.config/sway/config" \
  cfr="nvim $HOME/.config/river/init" \
  cfn="nvim $HOME/.config/niri/config.kdl" \
  cff="nvim $HOME/.config/foot/foot.ini"

#
# prompt
#

git_branch() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null) || return
  echo "$branch"
}

autoload -Uz colors && colors

PROMPT='%F{magenta}%~%f $(git_branch)
%F{yellow}:: %f'

eval "$(zoxide init zsh)"

_fix_cursor() {
   echo -ne '\e[5 q'
}

precmd_functions+=(_fix_cursor)

# new line after commands
typeset -g FIRST_PROMPT=1

precmd() {
  if [[ -n $FIRST_PROMPT ]]; then
    unset FIRST_PROMPT
  else
    print ""
  fi
}

[ -f "$ZDOTDIR/env" ] && source $ZDOTDIR/env

# bun completions
[ -s "/home/yrwq/.local/share/bun/_bun" ] && source "/home/yrwq/.local/share/bun/_bun"
