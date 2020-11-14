export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/.bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
ZSH_THEME="sunrise"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias v="nvim"
alias ga="git add --force"
alias gc="git commit -m"
alias gp="git push -u origin main"
alias ls="exa -a -l --icons"
alias l="exa --icons"

bindkey '^s'	backward-kill-word
bindkey '^d'	forward-word
bindkey '^a'	backward-word

export BROWSER="firefox"
export EDITOR="nvim"

export FFF_OPENER="xdg-open"
