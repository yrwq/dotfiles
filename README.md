<p align="center"> 
    <a href="#introduction"> <img width="150px" src=".assets/introduction.png"/> </a>
    <a href="#gallery"> <img width="150px" src=".assets/gallery.png"/> </a>
    <a href="#setup"> <img width="150px" src=".assets/setup.png"/> </a>
</p>

# Introduction

<img src=".assets/preview1.png" alt="img" align="right" width="500px">

This repository contains my personal collection of configuration files.  
Inspired by elena's [dotfiles](https://github.com/elenapan/dotfiles) and JavaCafe01's [dotfiles](https://github.com/JavaCafe01/dotfiles)  

I use the software above:

**Window Manager**: [awesome](https://awesomewm.org)  
**Text editor**: [doom-emacs](https://github.com/hlissner/doom-emacs)  
**Web browser**: [firefox](https://www.mozilla.org/en-US/firefox/)  
**Terminal**: [simple-terminal](https://st.suckless.org/)  
**Shell**: [zsh](https://github.com/ohmyzsh/ohmyzsh)  
**File manager**: [thunar](https://git.xfce.org/xfce/thunar/) [fff](https://github.com/dylanaraps/fff)  
**Music player**: [ncmpcpp](https://github.com/ncmpcpp/ncmpcpp)  
**Email client**: [neomutt](https://github.com/neomutt/neomutt)  

# Setup

1. Install awesome

 You need the git version, otherwise you can't use my setup
 
 ```sh
 yay -S awesome-git 
 ```
 
2. Install required fonts

 ```sh 
 git clone https://github.com/yrwq/dotfiles && cd dotfiles
 
 mkdir ~/.fonts
 
 cp fonts/* ~/.fonts/ -r
 
 fc-cache -fv
 ```
 
3. Install my awesomewm configuration

 First back up your current config
 ```sh
 mv ~/.config/awaesome ~/.config/awesome-backup
 ```

 Now copy my files
 ```sh
 cp config/awesome ~/.config/ -r 
 ```
  
4. Configure 
 
 Before using my config you should change the default applications, in `rc.lua` and `apps.lua`
 
# Gallery

<img src=".assets/preview1.png">
<img src=".assets/preview2.png">
