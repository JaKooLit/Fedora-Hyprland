
### Fedora-Hyprland install script based from my Arch-Hyprland-v4 [`Link`](https://github.com/JaKooLit/Hyprland-v4)

![alt text](https://github.com/JaKooLit/Fedora-Hyprland/blob/main/screenshots/dual_panel-light-dark-switch.png)

![alt text](https://github.com/JaKooLit/Fedora-Hyprland/blob/main/screenshots/default-light-dark.png)

### Installed on Nobara 🥰

![alt text](https://github.com/JaKooLit/Fedora-Hyprland/blob/main/screenshots/Hyprland-Nobara.png)


### you can find more screenshots in the screenshots directory

### ✨ Youtube presentation [`Link`](https://youtu.be/w2dt4GlHjV0?si=15JWMFH1wAEM2a5F)

### ✨  Some notes on installation
- This script is meant to install in any Fedora Work stations and its Spins.
- if starting from scratch, recommended spin to install is the Sway Spin. However, I have tested this script in Fedora Workstation (gnome), Plasma Spin and Sway
- I have not tested in any other spin. However, if you decided to try, recommend to install SDDM. Apart from GDM and SDDM, any other Login Manager may not work nor launch Hyprland. However, hyprland can be launched through tty by type Hyprland

#### WARNING! nwg-look takes long time to install. 
- nwg-look is a utility to costumize your GTK theme. It's a LXAppearance like. Its a good tool though but this package is entirely optional


### ✨ Costumize the packages and COPR Repos
- insde the install-scripts folder, you can edit 00-hypr-pkgs.sh, copr.sh

### NOTICE TO NVIDIA OWNERS ### 
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
- 
### ✨ Roadmap:
- [ ] Install zsh and oh-my-zsh without necessary steps above
- [ ] possibly adding gruvbox themes, cursors, icons
- [ ] adding vertical waybar 
- [X] ~~Use kitty in favor of foot~~ - Dropped the idea of kitty. Kitty is using twice memory compared to foot.

### ✨ some known issues
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

### 👍 CREDITS!
- shutout to one who created and maintaining the Hyprland COPR repo [`Hyprland COPR Link`](https://copr.fedorainfracloud.org/coprs/solopasha/hyprland/)
