#!/usr/bin/bash

pacman_archlinuxcn() {
  {
    echo "[archlinuxcn]"
    echo "SigLevel = Never"
    echo "Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux-cn/\$arch"
  } | sudo tee -a /etc/pacman.conf
  sudo pacman -Syu archlinuxcn-keyring | tee cnkeyring.log
  if grep -q "could not be locally signed." cnkeyring.log; then
    pacman_haveged
    rm cnkeyring.log
  else
    echo "no error"
    rm cnkeyring.log
  fi
  echo "[✔]archlinuxcn-keyring installed"
}

pacman_chaotic() {
  {
    echo "[chaotic-aur]"
    echo "SigLevel = Never"
    echo "Server = http://lonewolf-builder.duckdns.org/chaotic-aur/x86_64"
    echo "Server = http://chaotic.bangl.de/chaotic-aur/x86_64"
  } | sudo tee -a /etc/pacman.conf
  echo "[✔]chaotic-aur installed"
}

pacman_fermiarcs() {
  {
    echo "[fermiarcs]"
    echo "SigLevel = Never"
    echo "Server = https://pkg.fermiarcs.com:1443/archlinux/x86_64"
  } | sudo tee -a /etc/pacman.conf
  echo "[✔]fermiarcs repo installed"
}

pacman_aur() {
  sudo pacman -Syu fcitx5-chinese-addons-git fcitx5-gtk-git google-chrome \
    kernel-modules-hook nerd-fonts-complete sylpheed-beta-iconmod systemtap \
    visual-studio-code-bin yay
  echo "[✔] Installing aur packages"
}

pacman_base() {
  sudo pacman -Syu axel bind-tools cloc cmake cppcheck evince firefox flameshot \
    htop jdk-openjdk jq jre-openjdk jre-openjdk-headless libsodium lldb \
    lsb-release make mpv nano ncdu neofetch net-tools nload noto-fonts-cjk \
    noto-fonts-emoji noto-fonts-extra npm openssh p7zip pacman-contrib perf \
    pkgfile pkgstats python-pip python2-pip rdesktop rust screen shellcheck \
    shfmt telegram-desktop tldr translate-shell tree ttf-opensans unrar uptimed \
    valgrind wget yarn
  echo "[✔] Installing base utils"
}

pacman_haveged() {
  sudo pacman -Syu haveged
  sudo systemctl start haveged
  sudo systemctl enable haveged
  sudo rm -fr /etc/pacman.d/gnupg
  sudo pacman-key --init
  sudo pacman-key --populate archlinux
  sudo pacman-key --populate archlinuxcn
  sudo pacman -S --noconfirm archlinuxcn-keyring
  echo "[✔] Fix pacman archlinuxcn-keyring in gnupg-2.1"
}

pacman_mirrorlist() {
  sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
  echo "Server = https://mirrors.huaweicloud.com/archlinux/\$repo/os/\$arch" | sudo tee -a /etc/pacman.d/mirrorlist
}

pacman_init() {
  pacman_archlinuxcn
  pacman_chaotic
  pacman_fermiarcs
  pacman_mirrorlist
  pacman_base
  pacman_aur
}

fcitx5_profile() {
  sudo killall -9 fcitx5
  mkdir -p ~/.config/fcitx5
  rm ~/.config/fcitx5/profile
  cp conf/fcitx5_profile ~/.config/fcitx5/profile
}

fcitx5_wayland() {
  {
    echo "GTK_IM_MODULE=fcitx5"
    echo "QT_IM_MODULE=fcitx5"
    echo "XMODIFIERS=\"@im=fcitx\""
  } | tee ~/.pam_environment
  echo "[✔] Add fcitx5 config to pam_environment"
}

fcitx5_x11() {
  {
    echo "export GTK_IM_MODULE=fcitx5"
    echo "export XMODIFIERS=@im=fcitx5"
    echo "export QT_IM_MODULE=fcitx5"
    echo "fcitx5 &"
  } | tee -a ~/.xprofile
  echo "[✔] Add fcitx5 config to xprofile"
}

fcitx5_init() {
  fcitx5_profile
  case "${XDG_SESSION_TYPE}" in
  x11)
    fcitx5_profile
    fcitx5_x11
    ;;
  wayland)
    fcitx5_profile
    fcitx5_wayland
    ;;
  esac
}

change_omz() {
  sudo mkdir -p /usr/share/fonts/OTF/
  sudo pacman -S nerd-fonts-complete zsh zsh-autosuggestions
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

change_zshrc() {
  git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
  if grep "ZSH_THEME=\"robbyrussell\"" ~/.zshrc; then
    sed -i "s/ZSH_THEME=\"robbyrussell\"//" ~/.zshrc
    mkdir -p ~/.zsh
    cp conf/zsh/powerlevel9k.zsh ~/.zsh/powerlevel9k.zsh
    sed -i '1isource ~/.zsh/powerlevel9k.zsh' ~/.zshrc
    cp conf/zsh/custom.zsh ~/.zsh/custom.zsh
    sed -i '1isource ~/.zsh/custom.zsh' ~/.zshrc
  else
    echo "not found"
  fi
}

omz_init() {
  change_omz
  change_zshrc
}

spacevim() {
  sudo pacman -S vim
  curl -sLf https://spacevim.org/install.sh | bash
  vim
}

sound_panel() {
  sudo pacman -S pulseaudio xfce4-pulseaudio-plugin xfce4-panel pavucontrol
  echo "xfce4 volume panel installed"
}

xfceterminal_scheme() {
  git clone https://github.com/mbadolato/iTerm2-Color-Schemes ~/Documents/iTerm2-Color-Schemes
  mkdir -p ~/.local/share/xfce4/terminal
  cp -r ~/Documents/iTerm2-Color-Schemes/xfce4terminal/colorschemes ~/.local/share/xfce4/terminal/
  rm -rf ~/Documents/iTerm2-Color-Schemes
  echo "You can change xfce4-terminal Color theme at Edit >> Preferences >> Color >> Presets,
I recommand [Calamity] / [Builtin Tango Dark]."
}

konsole_scheme() {
  git clone https://github.com/mbadolato/iTerm2-Color-Schemes ~/Documents/iTerm2-Color-Schemes
  sudo cp ~/Documents/iTerm2-Color-Schemes/konsole/*.colorscheme /usr/share/konsole
  rm -rf ~/Documents/iTerm2-Color-Schemes
  echo "You can change Konsole Color theme at 
Konsole -> Settings -> Edit Current Profile -> Appearance -> select color template ,
I recommand [Breeze]."
}

kernel_lts() {
  case $(yay -Q nvidia | awk '{print $1}') in
  nvidia)
    sudo pacman -Rs nvidia
    sudo pacman -S linux-lts linux-lts-headers nvidia-lts
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    ;;
  *)
    case $(yay -Q linux | awk '{print $1}') in
    linux)
      sudo pacman -Rs linux
      sudo pacman -S linux-lts linux-lts-headers nvidia-lts
      sudo grub-mkconfig -o /boot/grub/grub.cfg
      ;;
    esac
    ;;
  esac
}

desktop_session() {
  case "${XDG_SESSION_DESKTOP}" in
  KDE)
    konsole_scheme
    ;;
  XFCE)
    sound_panel
    xfceterminal_scheme
    ;;
  esac
  omz_init
  spacevim
}

gpg_server() {
  gpg_conf="$HOME/.gnupg/gpg.conf"
  if [ -f "${gpg_conf}" ]; then
    if grep "keyserver" -q "${gpg_conf}"; then
      grep "keyserver" "${gpg_conf}"
    else
      echo "keyserver hkps://gpg.mozilla.org" | tee -a "${gpg_conf}"
    fi
  else
    mkdir -p "$HOME/.gnupg"
    echo "keyserver hkps://gpg.mozilla.org" | tee -a "${gpg_conf}"
  fi
}

dotfiles() {
  cp conf/clang-format ~/.clang-format
  gpg_server
}

pacman_init
fcitx5_init
desktop_session
dotfiles
kernel_lts
