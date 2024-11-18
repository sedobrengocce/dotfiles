#!/bin/bash

pm=""

function checkPM {
    pacman -V >/dev/null 2>/dev/null && pm="pacman" && return || \
    apt -v >/dev/null 2>/dev/null && pm="apt" && return || \
    brew -v >/dev/null 2>/dev/null && pm="brew" && return || \
    echo "Package manager not found. Exiting..."
    exit 1
}

function installGum {
    echo "Gum is not installed. Installing gum..."
    if [ "$pm" == "pacman" ]; then
        sudo pacman -S gum
    elif [ "$pm" == "brew" ]; then
        brew install gum
    elif [ "$pm" == "apt" ]; then
        apt install gum
    else
        echo "Package manager not found. Exiting..."
        exit 1
    fi
    gum -h >/dev/null 2>/dev/null || (echo "Gum installation failed. Exiting..." && exit 1)
    echo "Gum installed successfully."
    return
}

function installParu {
    echo "Paru is not installed. Installing paru..."
    $pm -S --noconfirm --needed base-devel git
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si
    cd ..
    rm -rf paru
    paru -h >/dev/null 2>/dev/null || (echo "Paru installation failed. Exiting..." && exit 1)
    echo "Paru installed successfully."
    pm="paru"
    return
}

# Check package manager
checkPM

# Check if gum is installed
gum -h >/dev/null 2>/dev/null || installGum

if [ "$pm" == "pacman" ]; then
    paru -h >/dev/null 2>/dev/null || installParu
fi

gum choose "op1" "op2" "op3" --header "Test" 

exit 0
