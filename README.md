<div align="center">

# 💌 ** JaKooLit's Fedora Hyprland Install Script ** 💌

![GitHub Repo stars](https://img.shields.io/github/stars/JaKooLit/Fedora-Hyprland?style=for-the-badge&color=cba6f7) ![GitHub last commit](https://img.shields.io/github/last-commit/JaKooLit/Fedora-Hyprland?style=for-the-badge&color=b4befe) ![GitHub repo size](https://img.shields.io/github/repo-size/JaKooLit/Fedora-Hyprland?style=for-the-badge&color=cba6f7)

<br/>
</div>!


### Fedora-Hyprland install script based from my Arch-Hyprland-v4 [`Link`](https://github.com/JaKooLit/Hyprland-v4)

![alt text](https://github.com/JaKooLit/screenshots/blob/main/Hyprland-ScreenShots/Fedora/dual-panel-dark_light-switch.png)

![alt text](https://github.com/JaKooLit/screenshots/blob/main/Hyprland-ScreenShots/Fedora/deafault-light-dark2.png)

### ❕ Installed on Nobara 🥰

![alt text](https://github.com/JaKooLit/screenshots/blob/main/Hyprland-ScreenShots/Fedora/Hyprland-Nobara.png)



### 📷 More Screenshots [`Link`](https://github.com/JaKooLit/screenshots/tree/main/Hyprland-ScreenShots/Fedora)


### ✨ Youtube presentation [`Link`](https://youtu.be/w2dt4GlHjV0?si=15JWMFH1wAEM2a5F)


### ✨ A video walk through my dotfiles[`Link`](https://youtu.be/fO-RBHvVEcc?si=ijqxxnq_DLiyO8xb)

## 🪧🪧🪧 ANNOUNCEMENT 🪧🪧🪧
- I have moved to a centralized Hyprland Dots/Configuration. [`Hyprland-Dots`](https://github.com/JaKooLit/Hyprland-Dots)

- after initial boot-up after install, you will experience a NO wallpaper. This is due to changes I made on the install scripts to correct that, you can press the light/dark button or choose wallpaper (SUPER CTRL W), and that wallpaper will be loaded after reboot or login.

- more info on announcement [`Link`](https://youtu.be/upDl1ns05eg)

If you want to use swaybg as wallpaper provider, you can edit ~/.config/hypr/configs/Execs.conf and uncomment the swaybg part


### ✨  Some notes on installation
- This install script was tested on Minimal Fedora using Fedora Everything - 21-Oct-2023
- This script is meant to install in any Fedora Work stations and its Spins.
- if starting from scratch, recommended spin to install is the Sway Spin. However, I have tested this script in Fedora Workstation (gnome), Plasma Spin and Sway
- I have not tested in any other spin. However, if you decided to try, recommend to install SDDM. Apart from GDM and SDDM, any other Login Manager may not work nor launch Hyprland. However, hyprland can be launched through tty by type Hyprland

### ⚠️ WARNING! nwg-look takes long time to install. 
- nwg-look is a utility to costumize your GTK theme. It's a LXAppearance like. Its a good tool though but this package is entirely optional


### ✨ Costumize the packages and COPR Repos
- inside the install-scripts folder, you can edit 00-hypr-pkgs.sh, copr.sh
- default GTK theme if agreed to be installed is Tokyo night GTK themes (dark and light) + Tokyo night SE icons

### 🔔 NOTICE TO NVIDIA OWNERS ### 
- by default it is installing the latest and newest nvidia drivers. If you have an older nvidia-gpu (GTX 800 series and older), check out nvidia-fedora website [`LINK`](https://rpmfusion.org/Howto/NVIDIA#Installing_the_drivers) and edit nvidia.sh in install-scripts folder to install proper gpu driver

### ✨ to run
> clone this repo by using git. Change directory, make executable and run the script
```bash
git clone https://github.com/JaKooLit/Fedora-Hyprland.git
cd Fedora-Hyprland
chmod +x install.sh
./install.sh
```
### ✨ for ZSH and OH-MY-ZSH installation
> do this once installed and script completed; do the following to change the default shell zsh
```bash
chsh -s $(which zsh)
zsh
source ~/.zshrc
```
- reboot or logout
- by default gnzh theme is installed. You can find more themes from this [`OH-MY-ZSH-THEMES`](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
- to change the theme, edit ~/.zshrc ZSH_THEME="desired theme"

### ✨ Hyprland Dot Notes
- super h for launching a small help file
- super e to view / edit settings, monitor, keybinds, Environment Variables, etc
- go through the keybinds. There are alot of hidden features like dual panel, change waybar styles, change wallpaper, etc... its too long to put all in the readme!!!
- super d for wofi (menu)
- super t for thunar (file manager)

### ✨ Packages that are manually downloaded and build. These packages will not be updated by apt and have to be manually updated
- nwg-look [`LINK`](https://github.com/nwg-piotr/nwg-look)
- a.) to update this package, in your installation folder, you can move that folder (nwg-look) or download manually, cd into it, and ran git pull && sudo make install

### ✨ Roadmap:
- [ ] Install zsh and oh-my-zsh without necessary steps above
- [ ] possibly adding gruvbox themes, cursors, icons
- [ ] adding vertical waybar 
- [X] ~~Use kitty in favor of foot~~ - Dropped the idea of kitty. Kitty is using twice memory compared to foot.

### ❗ some known issues
- reports from members of my discord, states that some users of nvidia are getting stuck on sddm login. credit  to @Kenni Fix stated was 
```  
 while in sddm press ctrl+alt+F2 or F3
log into your account
`lspci -nn`, find the id of your nvidia card
`ls /dev/dri/by-path` find the matching id
`ls -l /dev/dri/by-path` to check where the symlink points to 
)
7. add "env = WLR_DRM_DEVICES,/dev/dri/cardX" to the ENVvariables config (.config/hypr/configs/ENVariables.conf)  ; X being where the symlink of the gpu points to
```
- more info from the hyprland wiki [`Hyprland Wiki Link`](https://wiki.hyprland.org/FAQ/#my-external-monitor-is-blank--doesnt-render--receives-no-signal-laptop)

- Fedora Sway Specific - swaylock conflicts with swaylock-effects. Lock screen would be only white. If decided to remove swaylock in favor with swaylock-effects, sway will be removed. So care

### 👍👍👍 Thanks and Credits!
- a shout out to the one who created and maintaining Hyprland COPR Repo [`HYPRLAND COPR REPO`](https://copr.fedorainfracloud.org/coprs/solopasha/hyprland/)
- shout out to CooSee from Gentoo forums for the nice rainbow borders


## 💖 Support
- a Star on my Github repos would be nice 🌟

- Subscribe to my Youtube Channel [YouTube](https://www.youtube.com/@Ja.KooLit) 

- You can also buy me Coffee Through ko-fi.com 🤩

<a href='https://ko-fi.com/jakoolit' target='_blank'><img height='35' style='border:0px;height:46px;' src='https://az743702.vo.msecnd.net/cdn/kofi3.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' />