#!/bin/bash
echo "**************************************************"
git clone https://github.com/mbadolato/iTerm2-Color-Schemes ~/Documents/iTerm2-Color-Schemes
mkdir -p ~/.local/share/xfce4/terminal
cp -r ~/Documents/iTerm2-Color-Schemes/xfce4terminal/colorschemes ~/.local/share/xfce4/terminal/  
rm -rf ~/Documents/iTerm2-Color-Schemes
echo "You can change xfce4-terminal Color theme at 
Konsole >> Edit >> Preferences >> Color >> Presets,
I recommand [Calamity]."
pacman -S --noconfirm nerd-fonts-complete
echo "You can change xfce4-terminal font at
Konsole >> Edit >> Preferences >> Appearance,
I recommand [SauceCodePro Nerd Font Mono Medium]."
echo "**************************************************"
pacman -S --noconfirm zsh zsh-autosuggestions
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s /bin/zsh
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
before = 'ZSH_THEME="robbyrussell"'
after = '# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel9k/powerlevel9k"
# Left
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable vcs)
# Right
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs history ram load time)
# for nerd-font
POWERLEVEL9K_MODE="nerdfont-complete"
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
'
sed -i "s/$before/$after/g" ~/.zshrc
pacman -S --noconfirm vim
curl -sLf https://spacevim.org/install.sh | bash
vim
