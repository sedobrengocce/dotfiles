#!/bin/bash

pwd=`pwd`

packages=""

function select_packages() {
    exec 3>&1

    packages=`whiptail --title "Pepj dotfiles installer" --checklist "Select packages to install:" 20 61 15 \
        "tmux" "Terminal multiplexer" ON \
        "zsh" "Z shell" ON \
        "hypr" "Hyprland" ON \
        "nvim" "Neovim" ON \
        "vifm" "Vifm" ON \
        "kitty" "Kitty" ON \
        "mpv" "Mpv" ON \
        "utils" "Utils" OFF \
        "chrome" "Google Chrome" OFF \
        "gimp" "GIMP" OFF \
        "blender" "Blender" OFF \
        "telegram" "Telegram" OFF \
        2>&1 1>&3`

    exec 3>&-
}

function install_yay() {
    exec 3>&1
    local pass=`whiptail --title "Pepj dotfiles installer" --passwordbox "Enter your password" 10 60 2>&1 1>&3`
    exec 3>&-
    sudo -S <<< $pass pacman -S --noconfirm --needed base-devel git wget unzip
    cd ~
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
    cd $pwd
}

function install_packages() {
    exec 3>&1
    exec 3>&-
    local pacman_packages=""
    local aur_packages=""
    for package in $packages; do
        if [[ $package == *"chrome"* ]]; then
            yay -Sy google-chrome
        fi
        if [[ $package == *"gimp"* ]]; then
            yay -Sy --noconfirm --needed gimp
        fi
        if [[ $package == *"blender"* ]]; then
            yay -Sy --noconfirm --needed blender
        fi
        if [[ $package == *"telegram"* ]]; then
            yay -Sy --noconfirm --needed telegram-desktop
        fi
        if [[ $package == *"utils"* ]]; then
            yay -Sy pass\
                browserpass \
                pacman-contrib \
                bat
        fi
        if [[ $package == *"zsh"* ]]; then 
            yay -Sy --noconfirm --needed zsh python-pip pyenv
            cd ~
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
            pyenv install 2.7.18
            pyenv init
            export PYENV_ROOT="$HOME/.pyenv"
            command -v pyenv > /devl/null || export PATH="$PYENV_ROOT/bin:$PATH"
            eval "$(pyenv init -)"
            pyenv shell 2.7.18
            pip install ntfy
            yay -Sy --noconfirm --needed neofetch \
                fzf \
                thefuck \
                speech-dispatcher \
                lsd \
                nodejs \
                timer-bin \
                clp-git \
                npm
            cd $pwd
        fi
        if [[ $packages == *"tmux"* ]]; then
            yay -Sy --noconfirm --needed tmux
        fi
        if [[ $packages == *"hypr"* ]]; then
            yay -Sy --noconfirm --needed hyprland \
                polkit-gnome \
                ffmpeg \
                viewnior \
                pipewire \
                pipewire-alsa \
                pipewire-audio \
                pipewire-pulse \
                pipewire-jack \
                wireplumber \
                gst-plugin-pipewire \
                pavucontrol \
                starship \
                wl-clipboard \
                wf-recorder \
                swaybg \
                grimblast-git \
                ffmpegthumbnailer \
                tumbler \
                playerctl \
                noise-suppression-for-voice \
                waybar-hyprland-git \
                wlogout \
                swaylock-effects \
                sddm-git \
                pamixer \
                nwg-look-bin \
                nordic-theme \
                papirus-icon-theme \
                dunst \
                otf-sora \
                ttf-nerd-fonts-symbols-common \
                otf-firamono-nerd inter-font \
                ttf-fantasque-nerd \
                noto-fonts \
                noto-fonts-emoji \
                ttf-comfortaa \
                ttf-jetbrains-mono-nerd \
                ttf-icomoon-feather \
                ttf-iosevka-nerd \
                adobe-source-code-pro-fonts \
                brightnessctl \
                hyprpicker-git \
                fuzzel \
                btop \
                bluez \
                bluez-utils \
                blueman
        fi
        if [[ $packages == *"nvim"* ]]; then
            yay -Sy --noconfirm --needed neovim ripgrep
        fi
        if [[ $packages == *"vifm"* ]]; then
            yay -Sy --noconfirm --needed vifm
        fi
        if [[ $packages == *"kitty"* ]]; then
            yay -Sy --noconfirm --needed kitty
            mkdir -p ./tmp
            cd tmp
            wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip
            unzip FiraCode.zip
            mkdir -p ~/.local/share/fonts/
            mv *.ttf ~/.local/share/fonts/
            cd ..
            rm -rf ./tmp
        fi
        if [[ $packages == *"mpv"* ]]; then
            yay -Sy --noconfir needed mpv
        fi
    done
}

function copy_config() {
    mkdir -p ~/.config

    if [[ $packages == *"tmux"* ]]; then
        ln -s $PWD/tmux.conf ~/.tmux.conf
        ln -s $PWD/tmux ~/.tmux
    fi
    if [[ $packages == *"hypr"* ]]; then
        ln -s $PWD/hypr ~/.config/hypr
        ln -s $PWD/waybar ~/.config/waybar
        ln -s $PWD/wlogout ~/.config/wlogout
        ln -s $PWD/swaylock ~/.config/swaylock
        ln -s $PWD/fuzzel ~/.config/fuzzel
        ln -s $PWD/btop ~/.config/btop
    fi
    if [[ $packages == *"nvim"* ]]; then
        ln -s $PWD/nvim ~/.config/nvim
    fi
    if [[ $packages == *"vifm"* ]]; then
        ln -s $PWD/vifm ~/.config/vifm
    fi
    if [[ $packages == *"kitty"* ]]; then
        ln -s $PWD/kitty ~/.config/kitty
    fi
    if [[ $packages == *"mpv"* ]]; then
        ln -s $PWD/mpv ~/.config/mpv
    fi
    if [[ $packages == *"zsh"* ]]; then
        ln -s $PWD/zshrc ~/.zshrc
        ln -s $PWD/ntfy ~/.config/ntfy
        ln -s $PWD/neofetch ~/.config/neofetch
        ln -s $PWD/oh-my-zsh-theme/pepj.zsh-theme ~/.oh-my-zsh/themes/pepj.zsh-theme
        mkdir -p ~/.oh-my-zsh/plugins/pepj
        ln -s $PWD/oh-my-zsh-plugin/pepj.plugin.zsh ~/.oh-my-zsh/plugins/pepj/pepj.plugin.zsh
    fi
}

echo "Installing Base packages"
install_yay

select_packages

install_packages
copy_config
