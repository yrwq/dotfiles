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
This repository will always will be work in progress, so expect to find issues.
The configuration probably won't match your setup out-of-the-box, so you should edit the files to match your setup.

# Software

I use the software below, recommended to install them but not required.

|    Name    |        Purpose    |
|:----------:|:-----------------:|
| Vim |    Text Editor    |
|   Brave |    Web Browser    |
|     st    | Terminal Emulator |
|     Zsh    |       Shell       |
|   Ncmpcpp  |    Music Player   |
|   Neomutt  |    Email Client   |
|  Newsboat  |     RSS Reader    |
|   lf |    File Manager   |

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

3. Install [bling](https://github.com/Nooo37/bling) (utilities for awesomewm)

   This is optional, but highly recommended.

   If you don't wanna use bling you should edit `rc.lua`

    ```sh
    git clone https://github.com/Nooo37/bling ~/.config/awesome/bling
    ```

4. Install scripts, wallpapers, etc. (optional)

    Before copying my scripts take a look at bin's [readme](https://github.com/yrwq/dotfiles/blob/main/bin/README.org)

    ```sh
    cp .bin ~/.bin -r
    ```

    Copy fonts

    ```sh
    cp .fonts ~/.fonts/ -r
    ```

    Before using my config you should change the default applications, in `rc.lua` and `apps.lua`

# Usage

## The file manager

	As a file manager, i choose [lf](https://github.com/gokcehan/lf) (as in "list files"), a terminal based one written in Go.

	I got the configuration files for lf from Luke Smith, and added some extra features.

	To preview images, you need to install [lfimg](https://github.com/cirala/lfimg).

	`git clone https://github.com/cirala/lfimg && cd lfimg`

	`make install`

# Gallery

![preview](https://0x0.st/i7Tl.png)
![preview](https://0x0.st/i7cZ.png)
![preview](https://0x0.st/i7cq.png)
![preview](https://0x0.st/i7cb.png)
![preview](https://0x0.st/i7cc.png)
