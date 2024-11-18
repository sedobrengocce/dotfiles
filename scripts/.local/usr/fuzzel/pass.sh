#!/bin/bash

shopt -s nullglob globstar

prefix=$HOME/.password-store
passFiles=($prefix/**/*.gpg)
passFiles=("${passFiles[@]#"$prefix/"}")
passFiles=("${passFiles[@]%.gpg}")
action_list="Read\nEdit\nGenerate\nRemove\nInsert"

chosen_action=$(echo -e "$action_list" | fuzzel --dmenu -p "Action: ")

if [[ $chosen_action == "Read" ]]; then
    chosen_pass=$(printf '%s\n' "${passFiles[@]}" | fuzzel --dmenu -p "Pass: ")
    pass -c $chosen_pass 2>/dev/null
elif [[ $chosen_action == "Edit" ]]; then
    chosen_pass=$(printf '%s\n' "${passFiles[@]}" | fuzzel --dmenu -p "Pass: ")
    kitty pass edit $chosen_pass
elif [[ $chosen_action == "Generate" ]]; then
    chosen_pass=$(fuzzel --dmenu -p "Name:")
    pass generate $chosen_pass 
elif [[ $chosen_action == "Remove" ]]; then
    chosen_pass=$(printf '%s\n' "${passFiles[@]}" | fuzzel --dmenu -p "Pass: ")
    kitty pass rm $chosen_pass
elif [[ $chosen_action == "Insert" ]]; then
    chosen_pass=$(fuzzel --dmenu -p "Name")
    kitty pass insert $chosen_pass
fi

