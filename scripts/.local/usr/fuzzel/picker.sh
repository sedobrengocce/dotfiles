#!/usr/bin/env bash

action_list="Pick HEX\nPick RGB\nPick HSV\nPick HSL\nPick CMYK"

action=$(echo -e $action_list | fuzzel --dmenu -i -p "Color Picker")

if [[ $action == "Pick HEX" ]]; then
    notify-send "Color Picker" "HEX"
    hyprpicker -a -f hex
elif [[ $action == "Pick RGB" ]]; then
    notify-send "Color Picker" "RGB"
    hyprpicker -a -f rgb
elif [[ $action == "Pick HSV" ]]; then
    notify-send "Color Picker" "HSV"
    hyprpicker -a -f hsv
elif [[ $action == "Pick HSL" ]]; then
    notify-send "Color Picker" "HSL"
    hyprpicker -a -f hsl
elif [[ $action == "Pick CMYK" ]]; then
    notify-send "Color Picker" "CMYK"
    hyprpicker -a -f cymk
fi 


