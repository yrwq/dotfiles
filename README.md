<p align="center">
    <a href="#introduction"> <img width="150px" src=".assets/introduction.png"/> </a>
    <a href="#software"> <img width="150px" src=".assets/software.png"/> </a>
    <a href="#setup"> <img width="150px" src=".assets/setup.png"/> </a>
    <a href="#gallery"> <img width="150px" src=".assets/gallery.png"/> </a>
</p>

# Introduction

This repository contains my personal collection of configuration files for linux.
Inspired by elena's [dotfiles](https://github.com/elenapan/dotfiles), JavaCafe01's [dotfiles](https://github.com/JavaCafe01/dotfiles) and Luke Smith's [dotfiles](https://github.com/LukeSmithxyz/voidrice)
I'm distro hopping a lot and i got tired of copying my dotfiles so i ended up here.
This repository will always be work in progress, so expect to find issues.
The configuration probably won't match your setup out-of-the-box, so you should edit the files to match your setup.

# Setup

1. Install awesome

    You need the git version, otherwise you can't use my setup

     ```sh
     yay -S awesome-git
     ```

2. Install my awesomewm configuration

    First back up your current configurations
    ```sh
    mv ~/.config ~/.config-backup

	mkdir ~/.config
    ```
    Clone this repository

    ```sh
    git clone https://github.com/yrwq/dotfiles && cd dotfiles
    ```

    Now copy my files
    ```sh
    cp config/awesome ~/.config/ -r
    ```

3. Install scripts, wallpapers, etc. (optional)

    ```sh
    cp .bin ~/.bin -r
    ```

    Copy fonts

    ```sh
    cp .fonts ~/.fonts/ -r
    ```

    Before using my config you should change the default applications, in `rc.lua` and `apps.lua`

# Software

## The window manager

The window manager of my choice is [awesome](https://awesomewm.org), because it's highly configurable and extensible.

- File structure
	- `rc.lua` Awesome loads this file first.
	- `theme.lua` Which colors to use, size of gaps, etc.
	- `apps.lua` Default applications.
	- `candy` Bar and panel themes
	- `icons` Icons used by notifications, etc.
	- `module` Notifications, titlebars, other popups.
	- `shit` Shitty daemons used by widgets
	- `widgets` Widgets used by bars, popups and panels.

## The file manager

As a file manager, i choose [lf](https://github.com/gokcehan/lf) (as in "list files"), a terminal based one written in Go.

I got the configuration files for lf from Luke Smith, and added some extra features.


# Gallery

![preview](https://0x0.st/i7Tl.png)
![preview](https://0x0.st/i7cZ.png)
![preview](https://0x0.st/i7cq.png)
![preview](https://0x0.st/i7OX.png)
![preview](https://0x0.st/i7cc.png)
