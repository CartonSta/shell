#!/usr/bin/bash

sound_panel() {
    sudo pacman -S pulseaudio xfce4-pulseaudio-plugin xfce4-panel pavucontrol
    echo "xfce4 volume panel installed"
}

change_scheme() {
    git clone https://github.com/mbadolato/iTerm2-Color-Schemes ~/Documents/iTerm2-Color-Schemes
    mkdir -p ~/.local/share/xfce4/terminal
    cp -r ~/Documents/iTerm2-Color-Schemes/xfce4terminal/colorschemes ~/.local/share/xfce4/terminal/
    rm -rf ~/Documents/iTerm2-Color-Schemes
    echo "You can change xfce4-terminal Color theme at Edit >> Preferences >> Color >> Presets,
I recommand [Calamity] / [Builtin Tango Dark]."
}

change_omz() {
    sudo pacman -S nerd-fonts-complete zsh zsh-autosuggestions
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

change_zshrc() {
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
    if grep "ZSH_THEME=\"robbyrussell\"" ~/.zshrc; then
        sed -i "s/ZSH_THEME=\"robbyrussell\"//" ~/.zshrc
        mkdir -p ~/.zsh
        echo 'ZSH_THEME="powerlevel9k/powerlevel9k"
# Left
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable vcs)
# Right
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs history ram load time)
# for nerd-font
POWERLEVEL9K_MODE="nerdfont-complete"
source /usr/share/doc/pkgfile/command-not-found.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
' | tee ~/.zsh/powerlevel9k.zsh
        sed -i '1isource ~/.zsh/powerlevel9k.zsh' ~/.zshrc
        sed -i '1ialias farsee="curl -F \"c=@-\" \"http://fars.ee/\""' ~/.zshrc
        sed -i '1iexport GPG_TTY=$(tty)' ~/.zshrc
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

sound_panel
change_scheme
omz_init
spacevim
