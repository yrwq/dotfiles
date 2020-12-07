<p align="center">
    <a href="#introduction"> <img width="150px" src=".assets/introduction.png"/> </a>
    <a href="#software"> <img width="150px" src=".assets/software.png"/> </a>
    <a href="#setup"> <img width="150px" src=".assets/setup.png"/> </a>
    <a href="#gallery"> <img width="150px" src=".assets/gallery.png"/> </a>
</p>

# Introduction

This repository contains my personal collection of configuration files for linux.
I'm distro hopping a lot and i got tired of copying my dotfiles so i ended up here.
This repository will always be work in progress, so expect to find issues.
The configuration probably won't match your setup out-of-the-box, so you should edit the files to match your setup.

# Setup

The install script provides a fully usable system, installing dependencies, an aur helper, my dotfiles and my wallpapers.

If you are brave enought to use it, and you are running an Arch based distro,

run these commands in your terminal:

`curl -Ss https://raw.githubusercontent.com/yrwq/dotfiles/main/install -o install`

`chmod +x install`

`./install` or `./install new` to create a new user for the dotfiles

# Software

## The window manager

The window manager of my choice is [awesome](https://awesomewm.org), because it's highly configurable and extensible.

- File structure
	- `rc.lua` Awesome loads this file first.
	- `theme.lua` Which colors to use, size of gaps, etc.
	- `apps.lua` Default applications.
	- `keys.lua` Key bindings.
	- `candy` Bar and panel themes
	- `icons` Icons used by notifications, etc.
	- `module` Notifications, titlebars, other popups.
	- `shit` Shitty daemons used by widgets
	- `widgets` Widgets used by bars, popups and panels.

## The file manager

As a file manager, i choose [lf](https://github.com/gokcehan/lf) (as in "list files"), a terminal based one written in Go.

- Basic keybindings:
	- `hjkl`: navigation
	- `e`: open file in $EDITOR
	- `g`: go to top
	- `G`: go to bottom
	- `D`: delete selected file(s)
	- `C`: copy selected file(s)
	- `M`: move selected file(s)
	- `Ctrl + n`: make a directory
	- `B`: bulk rename
	- `b`: set selected picture as wallpaper
	- `sd`: open a terminal in the same directory
	- `Pp`: preview image

## The terminal emulator

As a terminal, i choose [st](https://st.suckless.org), because it's fast and minimal.

You can find the build at `.local/src/st`, it is based on Luke's.

- Basic keybindings:
	- `Alt + j`: scroll up
	- `Alt + k`: scroll down
	- `Alt + c`: copy
	- `Alt + v`: paste
	- `Alt + Shift + k`: increase font size
	- `Alt + Shift + j`: increase font size
	- `Alt + j`: decrease font size
	- `Alt + l`: follow url
	- `Alt + o`: copy url

## Misc

For the colors, i use [flavours](https://github.com/Misterio77/flavours), a [base16](https://github.com/chriskempson/base16) colorscheme builder/manager. The program uses templates and schemes to theme my entire desktop with one command. I made a tiny bash script (`.local/bin/chth`), so i can choose a theme with rofi and apply it.

# Gallery

![preview](https://0x0.st/ihaD.png)
![preview](https://0x0.st/ihaG.png)
