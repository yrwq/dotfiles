#!/bin/zsh

export PATH="$PATH:$(du "$HOME/.local/bin" | cut -f2 | paste -sd ':')"
export PATH="$PATH:$HOME/.local/share/gem/ruby/2.7.0/bin"

# Default programs:
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="brave"
export READER="zathura"
export VISUAL="st -e nvim"
export PAGER="nvim -R"
export MANPAGER="nvim -c 'set ft=man' -"

# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"

#export XINITRC="${XDG_CONFIG_HOME:-$HOME/.config}/x11/xinitrc"
# export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs.
export NOTMUCH_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/notmuch-config"
export DOOMDIR="${XDG_CONFIG_HOME:-$HOME/.config}/doom"
export LESSHISTFILE="-"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

export XKB_DEFAULT_LAYOUT="hu"
