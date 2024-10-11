#!/bin/zsh

. "$HOME/.cargo/env"

# change this please
export XKB_DEFAULT_LAYOUT="hu"

export BUN_INSTALL="$HOME/.bun"
export MANPAGER="sh -c 'col -bx | bat -l man -p --paging always'"
export MANROFFOPT="-c"
export GTK_USE_PORTAL=1

export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/.local/share/go/bin"
export PATH="$PATH:$HOME/.config/emacs/bin"
export PATH="$BUN_INSTALL/bin:$PATH"

#
# default programs
#

export EDITOR="nvim"
export TERMINAL="wezterm"
export BROWSER="firefox"
export READER="zathura"
export VISUAL="neovide"

# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export NOTMUCH_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/notmuch-config"
export DOOMDIR="${XDG_CONFIG_HOME:-$HOME/.config}/doom"
export LESSHISTFILE="-"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/shell/inputrc"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export WINEPREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/wineprefixes/default"
export KODI_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/kodi"
export PASSWORD_STORE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/password-store"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export ANDROID_SDK_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/android"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export ANSIBLE_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/ansible/ansible.cfg"
export UNISON="${XDG_DATA_HOME:-$HOME/.local/share}/unison"
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/history"
export WEECHAT_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/weechat"

if [ "$TERM" = "linux" ]; then
  /bin/echo -e "
  \e]P0282828
  \e]P1cc241d
  \e]P298971a
  \e]P3d79921
  \e]P4458588
  \e]P5b16286
  \e]P6689d6a
  \e]P7a89984
  \e]P8928374
  \e]P9fb4934
  \e]PAb8bb26
  \e]PBfabd2f
  \e]PC83a598
  \e]PDd3869b
  \e]PE8ec07c
  \e]PFebdbb2
  "
  clear
fi

# start compositor if on tty1
# [ "$(tty)" = '/dev/tty1' ] && exec Hyprland
