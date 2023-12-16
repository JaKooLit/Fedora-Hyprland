<div align="center">

# 💌 ** JaKooLit's Fedora Hyprland Install Script ** 💌

![GitHub Repo stars](https://img.shields.io/github/stars/JaKooLit/Fedora-Hyprland?style=for-the-badge&color=cba6f7) ![GitHub last commit](https://img.shields.io/github/last-commit/JaKooLit/Fedora-Hyprland?style=for-the-badge&color=b4befe) ![GitHub repo size](https://img.shields.io/github/repo-size/JaKooLit/Fedora-Hyprland?style=for-the-badge&color=cba6f7)

<br/>
</div>!

#### 📷 Hyprland-Dots-v2 Featuring Rofi 
<p align="center">
    <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-ScreenShots/Fedora-v2/rofi.png" /> <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-ScreenShots/Fedora-v2/Light.png" />   
</p>

<p align="center">
    <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-Dots-Showcase/default-waybar.png" /> <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-Dots-Showcase/rofi.png" />   
   <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-Dots-Showcase/wlogout-dark.png" /> <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-Dots-Showcase/showcase2.png"" /> 
   <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-Dots-Showcase/waybar-layout.png" /> <img align="center" width="49%" src="https://raw.githubusercontent.com/JaKooLit/screenshots/main/Hyprland-Dots-Showcase/waybar-style.png"" /> 
</p>

### ❕ Installed on Nobara 🥰

![alt text](https://github.com/JaKooLit/screenshots/blob/main/Hyprland-ScreenShots/Fedora/Hyprland-Nobara.png)

### 📸 More up to date screenshots [`Link`](https://github.com/JaKooLit/screenshots/tree/main/Hyprland-Dots-Showcase)

###  📷 Older Screenshots [`V1`](https://github.com/JaKooLit/screenshots/tree/main/Hyprland-ScreenShots/Fedora) & [`V2`](https://github.com/JaKooLit/screenshots/tree/main/Hyprland-ScreenShots/Fedora-v2)


### ✨ Youtube presentation [`v1`](https://youtu.be/w2dt4GlHjV0)
### ✨ Youtube presentation [`v2`](https://youtu.be/_U_WR33XNYY)

### ✨ A video walk through my dotfiles[`Link`](https://youtu.be/fO-RBHvVEcc?si=ijqxxnq_DLiyO8xb)
### ✨ A video walk through of My Hyprland-Dots v2[`Link`](https://youtu.be/yaVurRoXc-s?si=iDnBC5S3thPBX3ZE)


## 🪧🪧🪧 ANNOUNCEMENT 🪧🪧🪧
- This Repo does not contain Hyprland Dots or configs! Dotfiles can be checked here [`Hyprland-Dots`](https://github.com/JaKooLit/Hyprland-Dots) . During installation, if you opt to copy installation, it will be downloaded from that centralized repo.
- Hyprland-Dots use are constantly evolving / improving. you can check CHANGELOGS here [`Hyprland-Dots-Changelogs`](https://github.com/JaKooLit/Hyprland-Dots/wiki/7.-CHANGELOGS)
- Since the Hyprland-Dots are evolving, some of the screenshots maybe old

### ✨  Some notes on installation / Pre-requisites
#### 💬 install a backup tool like `snapper` or `timeshift`. and Backup your system before installing hyprland using this script. This script does NOT include uninstallation of packages as it may break your system due to shared packages / libraries.
- This install script was tested on Minimal Fedora using Fedora Everything [`Link`](https://youtu.be/_U_WR33XNYY)
- This script is meant to install in any Fedora Work stations and its Spins.
- if starting from scratch, recommended spin to install is the Sway Spin. However, I have tested this script in Fedora Workstation (gnome), Plasma Spin and Sway
- I have not tested in any other spin. However, if you decided to try, recommend to install SDDM. Apart from GDM and SDDM, any other Login Manager may not work nor launch Hyprland. However, hyprland can be launched through tty by type Hyprland
- If you have nvidia, and wanted to use proprietary drivers, uninstall nouveau first (if installed). This script will be installing proprietary nvidia drivers and will not deal with removal of nouveau.

### ⚠️ WARNING! If you have GDM already as log-in manager, DO NOT install SDDM
- You will likely to encounter issues

### ⚠️ WARNING! nwg-look takes long time to install. 
- nwg-look is a utility to costumize your GTK theme. It's a LXAppearance like. Its a good tool though but this package is entirely optional


### ✨ Costumize the packages and COPR Repos
- inside the install-scripts folder, you can edit 00-hypr-pkgs.sh, copr.sh, etc. Care though as the Hyprland Dots might not work properly
- default GTK theme if agreed to be installed is Tokyo night GTK themes (dark and light) + Tokyo night SE icons + Bibata Cursor

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
> installer should auto change your default shell to zsh. However, if it does not, do this
```bash
chsh -s $(which zsh)
zsh
source ~/.zshrc
```
- reboot or logout
- by default agnoster theme is installed. You can find more themes from this [`OH-MY-ZSH-THEMES`](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
- to change the theme, edit ~/.zshrc ZSH_THEME="desired theme"

### ✨ TO DO once installation done and dotfiles copied
- ~~if you opted to install gtk themes, to apply the theme and icon, press the dark/light button (beside the padlock). To apply Bibata modern ice cursor, launch nwg-look (GTK Settings) through rofi.~~ Hyprland-Dots v2.1.18, initial boot file will attempt to apply GTK themes,cursor, and icons. You can tweak more using nwg-look (GTK-Settings) utility

- SUPER H for HINT or click on the waybar HINT! Button 
- Head over to [FAQ](https://github.com/JaKooLit/Hyprland-Dots/wiki/4.-FAQ) and [TIPS](https://github.com/JaKooLit/Hyprland-Dots/wiki/5.-TIPS)


### ✨ Packages that are manually downloaded and build. These packages will not be updated by dnf and have to be manually updated
- nwg-look [`LINK`](https://github.com/nwg-piotr/nwg-look)
- a.) to update this package, in your installation folder, you can move that folder (nwg-look) or download manually, cd into it, and ran git pull && sudo make install

### 🏴‍☠️🏴‍☠️🏴‍☠️ Got a questions regarding the Hyprland Dots?
- Head over to wiki Link [`WIKI`](🏴https://github.com/JaKooLit/Hyprland-Dots/wiki)


### 🛣️ Roadmap:
- ~~[ ] Install zsh and oh-my-zsh without necessary steps above~~ DONE 
- [ ] possibly adding gruvbox themes, cursors, icons

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

### 📒 Final Notes
- join my discord channel [`Discord`](https://discord.gg/V2SJ92vbEN)
- Feel free to copy, re-distribute, and use this script however you want. Would appreciate if you give me some loves by crediting my work :)

### 👍👍👍 Thanks and Credits!
- [`Hyprland`](https://hyprland.org/) Of course to Hyprland and @vaxerski for this awesome Dynamic Tiling Manager.
- [`HYPRLAND COPR REPO`](https://copr.fedorainfracloud.org/coprs/solopasha/hyprland/) - a shout out to the one who created and maintaining Hyprland COPR Repo 
- shout out to CooSee from Gentoo forums for the nice rainbow borders

## 💖 Support
- a Star on my Github repos would be nice 🌟

- Subscribe to my Youtube Channel [YouTube](https://www.youtube.com/@Ja.KooLit) 

- You can also buy me Coffee Through ko-fi.com 🤩

<a href='https://ko-fi.com/jakoolit' target='_blank'><img height='35' style='border:0px;height:46px;' src='https://az743702.vo.msecnd.net/cdn/kofi3.png?v=0' border='0' alt='Buy Me a Coffee at ko-fi.com' />
