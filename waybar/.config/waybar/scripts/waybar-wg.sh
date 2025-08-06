#!/bin/bash

STATUS_CONNECTED_STR='{"text":"Connected","class":"connected","alt":"connected"}'
STATUS_DISCONNECTED_STR='{"text":"Disconnected","class":"disconnected","alt":"disconnected"}'

function insertPass {
    return $(fuzzel --dmenu --password -l 0 -p "Enter sudo password: ")
}

function checkIP {
    return $(ip addr | rg wg0 | rg inet | awk '{print $2}' | cut -d'/' -f1)
}

function checkStatus {
    return $(ip addr | rg wg0 | wc -l)
}

function toggleVPN {
    local pass=$(insertPass)
    local wgStatus=$(checkStatus)
    if [ $wgStatus -eq 0 ]; then
        sudo -S <<< $pass wg-quick up wg0
    else
        sudo -S <<< wg-quick down wg0
    fi
}

case $1 in
    --toggle)
        toggleVPN
        ;;
    --status)
        checkStatus && echo $STATUS_CONNECTED_STR || echo $STATUS_DISCONNECTED_STR
        ;;
    --ip)
        checkIP
        ;;
    *)
        echo "Invalid argument"
        ;;
esac
