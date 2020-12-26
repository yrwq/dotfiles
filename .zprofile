#!/bin/zsh

# Adds `~/.local/bin` to $PATH
export PATH="$PATH:$(du "$HOME/.local/bin" | cut -f2 | paste -sd ':')"
export PATH="$PATH:$HOME.gem/ruby/2.7.0/bin"

# Default programs:
export EDITOR="$(which nvim)"
export TERMINAL="$(which st)"
export BROWSER="$(which brave-dev)"
export READER="$(which zathura)"
export VISUAL="emacsclient -c"
export PAGER="${EDITOR:="$(which nvim)"} -R"
export OPENER="${HOME:="/home/$USER"}/.local/bin/open"
export MANPAGER="${EDITOR:="$(which nvim)"} -c 'set ft=man' -"

# ~/ Clean-up:
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export GPG_AGENT_INFO=""
#export XINITRC="${XDG_CONFIG_HOME:-$HOME/.config}/x11/xinitrc"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # This line will break some DMs.
export NOTMUCH_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/notmuch-config"
export DOOMDIR="${XDG_CONFIG_HOME:-$HOME/.config}/doom"
export GTK2_RC_FILES="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-2.0/gtkrc-2.0"
export LESSHISTFILE="-"
export WGETRC="${XDG_CONFIG_HOME:-$HOME/.config}/wget/wgetrc"
export INPUTRC="${XDG_CONFIG_HOME:-$HOME/.config}/shell/inputrc"
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
#export ALSA_CONFIG_PATH="$XDG_CONFIG_HOME/alsa/asoundrc"
#export GNUPGHOME="${XDG_DATA_HOME:-$HOME/.local/share}/gnupg"
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

# Other program settings: export DICS="/usr/share/stardict/dic/"
export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"
export QT_QPA_PLATFORMTHEME="gtk2"	# Have QT use gtk2 theme.
export MOZ_USE_XINPUT2="1"		# Mozilla smooth scrolling/touchpads.
export AWT_TOOLKIT="MToolkit wmname LG3D"	#May have to install wmname
export _JAVA_AWT_WM_NONREPARENTING=1	# Fix for Java applications in dwm

# This is the list for lf icons:
export LF_ICONS="di= :\
fi= :\
tw= :\
ow= :\
ln= :\
or= :\
ex= :\
*.txt= :\
*.mom= :\
*.me= :\
*.ms= :\
*.png= :\
*.webp= :\
*.ico= :\
*.jpg= :\
*.jpe= :\
*.jpeg= :\
*.gif= :\
*.svg= :\
*.tif= :\
*.tiff= :\
*.xcf= :\
*.html=爵:\
*.xml=爵:\
*.gpg=:\
*.css= :\
*.pdf= :\
*.djvu= :\
*.epub= :\
*.csv= :\
*.xlsx= :\
*.tex= :\
*.md= :\
*.r= :\
*.R= :\
*.rmd= :\
*.Rmd= :\
*.m= :\
*.mp3= :\
*.opus= :\
*.ogg= :\
*.m4a= :\
*.flac= :\
*.wav= :\
*.mkv= :\
*.mp4= :\
*.webm= :\
*.mpeg= :\
*.avi= :\
*.mov= :\
*.mpg= :\
*.wmv= :\
*.m4b= :\
*.flv= :\
*.zip= :\
*.rar= :\
*.7z= :\
*.tar.gz= :\
*.1=ℹ:\
*.nfo=ℹ:\
*.info=ℹ:\
*.log= :\
*.iso=﫭:\
*.img=﫭:\
*.part= :\
*.torrent= :\
"

[ ! -f ${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc ] && shortcuts >/dev/null 2>&1 &

[ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1 && exec startx
